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
, ps
, bats
, lsof
, callPackages
, symlinkJoin
, makeWrapper
, runCommand
, doInstallCheck ? true
}:

resholve.mkDerivation rec {
  pname = "bats";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "bats-core";
    repo = "bats-core";
    rev = "v${version}";
    sha256 = "sha256-joNne/dDVCNtzdTQ64rK8GimT+DOWUa7f410hml2s8Q=";
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
      ];
      fake = {
        external = [
          "greadlink"
          "shlock"
        ];
      };
      fix = {
        "$BATS_ROOT" = [ "${placeholder "out"}" ];
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
        "$report_formatter" = true;
        "$formatter" = true;
        "$pre_command" = true;
        "$BATS_TEST_NAME" = true;
        "${placeholder "out"}/libexec/bats-core/bats-exec-test" = true;
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

  passthru.tests.libraries = runCommand "${bats.name}-with-libraries-test" {
    testScript = ''
      setup() {
        bats_load_library bats-support
        bats_load_library bats-assert

        bats_require_minimum_version 1.5.0
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
    '';
    passAsFile = [ "testScript" ];
  } ''
    ${bats.withLibraries (p: [ p.bats-support p.bats-assert ])}/bin/bats "$testScriptPath"
    touch "$out"
  '';

  passthru.tests.upstream = bats.unresholved.overrideAttrs (old: {
    name = "${bats.name}-tests";
    dontInstall = true; # just need the build directory
    installCheckInputs = [
      ncurses
      parallel # skips some tests if it can't detect
      flock # skips some tests if it can't detect
      ps
    ] ++ lib.optionals stdenv.isDarwin [ lsof ];
    inherit doInstallCheck;
    installCheckPhase = ''
      # TODO: cut if https://github.com/bats-core/bats-core/issues/418 allows
      sed -i '/test works even if PATH is reset/a skip "disabled for nix build"' test/bats.bats

      # skip tests that assume bats `install.sh` will be in BATS_ROOT
      rm test/root.bats

      # test generates file with absolute shebang dynamically
      substituteInPlace test/install.bats --replace \
        "/usr/bin/env bash" "${bash}/bin/bash"

      ${bats}/bin/bats test
      touch $out
    '';
  });

  meta = with lib; {
    homepage = "https://github.com/bats-core/bats-core";
    description = "Bash Automated Testing System";
    maintainers = with maintainers; [ abathur ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
