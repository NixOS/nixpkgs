{ resholve
, lib
, stdenv
, fetchFromGitHub
, bash
, coreutils
, gnugrep
, ncurses
, findutils
, hostname
, parallel
, flock
, procps
, bats
, lsof
, callPackages
, symlinkJoin
, makeWrapper
, runCommand
, doInstallCheck ? true
# packages that use bats (for update testing)
, bash-preexec
, kikit
, locate-dominating-file
, packcc
}:

resholve.mkDerivation rec {
  pname = "bats";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "bats-core";
    repo = "bats-core";
    rev = "v${version}";
    hash = "sha256-goHIhbBoCf1eb1N8xIHdVvAURofvLDgEDXofhDHrr7Y=";
  };

  patchPhase = ''
    patchShebangs .
  '';

  installPhase = ''
    ./install.sh $out
  '';

  solutions = {
    bats = {
      scripts = [
        "bin/bats"
        "libexec/bats-core/*"
        "lib/bats-core/*"
      ];
      interpreter = "${bash}/bin/bash";
      inputs = [
        bash
        coreutils
        gnugrep
        ncurses
        findutils
        hostname
        parallel
        flock
        "lib/bats-core"
        "libexec/bats-core"
        procps
      ];
      fake = {
        external = [
          "greadlink"
          "shlock"
        ] ++ lib.optionals stdenv.isDarwin [
          "pkill" # procps doesn't supply this on darwin
        ];
      };
      fix = {
        "$BATS_ROOT" = [ "${placeholder "out"}" ];
        "$BATS_LIBDIR" = [ "lib" ];
        "$BATS_LIBEXEC" = [ "${placeholder "out"}/libexec/bats-core" ];
      };
      keep = {
        "${placeholder "out"}/libexec/bats-core/bats" = true;
        source = [
          "${placeholder "out"}/lib/bats-core/validator.bash"
          "${placeholder "out"}/lib/bats-core/preprocessing.bash"
          "$BATS_TEST_SOURCE"
          "${placeholder "out"}/lib/bats-core/tracing.bash"
          "${placeholder "out"}/lib/bats-core/test_functions.bash"
          "$library_load_path"
          "${placeholder "out"}/lib/bats-core/common.bash"
          "${placeholder "out"}/lib/bats-core/semaphore.bash"
          "${placeholder "out"}/lib/bats-core/formatter.bash"
          "${placeholder "out"}/lib/bats-core/warnings.bash"
          "$setup_suite_file" # via cli arg
        ];
        "$interpolated_report_formatter" = true;
        "$interpolated_formatter" = true;
        "$pre_command" = true;
        "$BATS_TEST_NAME" = true;
        "${placeholder "out"}/libexec/bats-core/bats-exec-test" = true;
        "$BATS_LINE_REFERENCE_FORMAT" = "comma_line";
        "$BATS_LOCKING_IMPLEMENTATION" = "${flock}/bin/flock";
        "$parallel_binary_name" = "${parallel}/bin/parallel";
        "${placeholder "out"}/libexec/bats-core/bats-preprocess" = true;
      };
      execer = [
        /*
        both blatant lies for expedience; these can certainly exec args
        they may be safe here, because they may always run things that
        are ultimately in libexec?
        TODO: handle parallel and flock in binlore/resholve
        */
        "cannot:${parallel}/bin/parallel"
        "cannot:${flock}/bin/flock"

        "cannot:libexec/bats-core/bats-preprocess"

        # these do exec, but other internal files
        "cannot:libexec/bats-core/bats-exec-file"
        "cannot:libexec/bats-core/bats-exec-suite"
        "cannot:libexec/bats-core/bats-gather-tests"
      ] ++ lib.optionals (!stdenv.isDarwin) [
        # checked invocations for exec
        "cannot:${procps}/bin/pkill"
      ];
    };
  };

  passthru.libraries = callPackages ./libraries.nix {};

  passthru.withLibraries = selector:
    symlinkJoin {
      name = "bats-with-libraries-${bats.version}";

      paths = [
        bats
      ] ++ selector bats.libraries;

      nativeBuildInputs = [
        makeWrapper
      ];

      postBuild = ''
        wrapProgram "$out/bin/bats" \
          --suffix BATS_LIB_PATH : "$out/share/bats"
      '';
    };

  passthru.tests = {
    libraries = runCommand "${bats.name}-with-libraries-test" {
      testScript = ''
        setup() {
          bats_load_library bats-support
          bats_load_library bats-assert
          bats_load_library bats-file
          bats_load_library bats-detik/detik.bash

          bats_require_minimum_version 1.5.0

          TEST_TEMP_DIR="$(temp_make --prefix 'nixpkgs-bats-test')"
        }

        teardown() {
          temp_del "$TEST_TEMP_DIR"
        }

        @test echo_hi {
          run -0 echo hi
          assert_output "hi"
        }

        @test cp_failure {
          run ! cp
          assert_line --index 0 "cp: missing file operand"
          assert_line --index 1 "Try 'cp --help' for more information."
        }

        @test file_exists {
          echo "hi" > "$TEST_TEMP_DIR/hello.txt"
          assert_file_exist "$TEST_TEMP_DIR/hello.txt"
          run cat "$TEST_TEMP_DIR/hello.txt"
          assert_output "hi"
        }
      '';
      passAsFile = [ "testScript" ];
    } ''
      ${bats.withLibraries (p: [ p.bats-support p.bats-assert p.bats-file p.bats-detik ])}/bin/bats "$testScriptPath"
      touch "$out"
    '';

    upstream = bats.unresholved.overrideAttrs (old: {
      name = "${bats.name}-tests";
      dontInstall = true; # just need the build directory
      nativeInstallCheckInputs = [
        ncurses
        parallel # skips some tests if it can't detect
        flock # skips some tests if it can't detect
        procps
      ] ++ lib.optionals stdenv.isDarwin [ lsof ];
      inherit doInstallCheck;
      installCheckPhase = ''
        # TODO: cut if https://github.com/bats-core/bats-core/issues/418 allows
        sed -i '/test works even if PATH is reset/a skip "disabled for nix build"' test/bats.bats

        # skip tests that assume bats `install.sh` will be in BATS_ROOT
        rm test/root.bats

        '' + (lib.optionalString stdenv.hostPlatform.isDarwin ''
        # skip new timeout tests which are failing on macOS for unclear reasons
        # This might relate to procps not having a pkill?
        rm test/timeout.bats
        '') + ''

        # test generates file with absolute shebang dynamically
        substituteInPlace test/install.bats --replace \
          "/usr/bin/env bash" "${bash}/bin/bash"

        ${bats}/bin/bats test
        touch $out
      '';
    });

    # to see when updates would break things, include packages
    # that use nixpkgs' bats for testing (as long as they
    # aren't massive builds)
    inherit bash-preexec locate-dominating-file packcc;
    resholve = resholve.tests.cli;
  } // lib.optionalAttrs (!stdenv.isDarwin) {
    # TODO: kikit's kicad dependency is marked broken on darwin atm
    # may be able to fold this up if that resolves.
    inherit kikit;
  };

  meta = with lib; {
    homepage = "https://github.com/bats-core/bats-core";
    description = "Bash Automated Testing System";
    mainProgram = "bats";
    maintainers = with maintainers; [ abathur ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
