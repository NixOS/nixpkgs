{ stdenv
, callPackage
, fetchFromGitHub
, fetchurl
, lib
  # Dependencies
, boehmgc
, coreutils
, git
, gmp
, hostname
, libatomic_ops
, libevent
, libiconv
, libxml2
, libyaml
, llvmPackages
, makeWrapper
, openssl
, pcre
, pkg-config
, readline
, tzdata
, which
, zlib
}:

# We need multiple binaries as a given binary isn't always able to build
# (even slightly) older or newer versions.
# - 0.26.1 can build 0.25.x and 0.26.x but not 0.27.x
# - 0.27.2 can build 0.27.x but not 0.25.x, 0.26.x and 0.29.x
#
# We need to keep around at least the latest version released with a stable
# NixOS
let
  archs = {
    x86_64-linux = "linux-x86_64";
    i686-linux = "linux-i686";
    x86_64-darwin = "darwin-x86_64";
  };

  arch = archs.${stdenv.system} or (throw "system ${stdenv.system} not supported");

  checkInputs = [ git gmp openssl readline libxml2 libyaml ];

  genericBinary = { version, sha256s, rel ? 1 }:
    stdenv.mkDerivation rec {
      pname = "crystal-binary";
      inherit version;

      src = fetchurl {
        url = "https://github.com/crystal-lang/crystal/releases/download/${version}/crystal-${version}-${toString rel}-${arch}.tar.gz";
        sha256 = sha256s.${stdenv.system};
      };

      buildCommand = ''
        mkdir -p $out
        tar --strip-components=1 -C $out -xf ${src}
      '';
    };

  commonBuildInputs = extraBuildInputs: [
    boehmgc
    libatomic_ops
    pcre
    libevent
    libyaml
    zlib
    libxml2
    openssl
  ] ++ extraBuildInputs
  ++ lib.optionals stdenv.isDarwin [ libiconv ];

  generic = (
    { version
    , sha256
    , binary
    , doCheck ? true
    , extraBuildInputs ? [ ]
    , buildFlags ? [ "all" "docs" ]
    }:
    lib.fix (compiler: stdenv.mkDerivation {
      pname = "crystal";
      inherit buildFlags doCheck version;

      src = fetchFromGitHub {
        owner = "crystal-lang";
        repo = "crystal";
        rev = version;
        inherit sha256;
      };

      outputs = [ "out" "lib" "bin" ];

      postPatch = ''
        # Add dependency of crystal to docs to avoid issue on flag changes between releases
        # https://github.com/crystal-lang/crystal/pull/8792#issuecomment-614004782
        substituteInPlace Makefile \
          --replace 'docs: ## Generate standard library documentation' 'docs: crystal ## Generate standard library documentation'

        substituteInPlace src/crystal/system/unix/time.cr \
          --replace /usr/share/zoneinfo ${tzdata}/share/zoneinfo

        ln -sf spec/compiler spec/std

        # Dirty fix for when no sandboxing is enabled
        rm -rf /tmp/crystal
        mkdir -p /tmp/crystal

        substituteInPlace spec/std/file_spec.cr \
          --replace '/bin/ls' '${coreutils}/bin/ls' \
          --replace '/usr/share' '/tmp/crystal' \
          --replace '/usr' '/tmp'

        substituteInPlace spec/std/process_spec.cr \
          --replace '/bin/cat' '${coreutils}/bin/cat' \
          --replace '/bin/ls' '${coreutils}/bin/ls' \
          --replace '/usr/bin/env' '${coreutils}/bin/env' \
          --replace '"env"' '"${coreutils}/bin/env"' \
          --replace '"/usr"' '"/tmp"'

        substituteInPlace spec/std/socket/tcp_server_spec.cr \
          --replace '{% if flag?(:gnu) %}"listen: "{% else %}"bind: "{% end %}' '"bind: "'

        substituteInPlace spec/std/system_spec.cr \
          --replace '`hostname`' '`${hostname}/bin/hostname`'

        # See https://github.com/crystal-lang/crystal/pull/8640
        substituteInPlace spec/std/http/cookie_spec.cr \
          --replace '01 Jan 2020' '01 Jan #{Time.utc.year + 2}'

        # See https://github.com/crystal-lang/crystal/issues/8629
        substituteInPlace spec/std/socket/udp_socket_spec.cr \
          --replace 'it "joins and transmits to multicast groups"' 'pending "joins and transmits to multicast groups"'

        # See https://github.com/crystal-lang/crystal/pull/8699
        substituteInPlace spec/std/xml/xml_spec.cr \
          --replace 'it "handles errors"' 'pending "handles errors"'
      '';

      buildInputs = commonBuildInputs extraBuildInputs;

      nativeBuildInputs = [ binary makeWrapper which pkg-config llvmPackages.llvm ];

      makeFlags = [
        "CRYSTAL_CONFIG_VERSION=${version}"
      ];

      LLVM_CONFIG = "${llvmPackages.llvm.dev}/bin/llvm-config";

      FLAGS = [
        "--release"
        "--single-module" # needed for deterministic builds
      ];

      # This makes sure we don't keep depending on the previous version of
      # crystal used to build this one.
      CRYSTAL_LIBRARY_PATH = "${placeholder "lib"}/crystal";

      # We *have* to add `which` to the PATH or crystal is unable to build
      # stuff later if which is not available.
      installPhase = ''
        runHook preInstall

        install -Dm755 .build/crystal $bin/bin/crystal
        wrapProgram $bin/bin/crystal \
          --suffix PATH : ${lib.makeBinPath [ pkg-config llvmPackages.clang which ]} \
          --suffix CRYSTAL_PATH : lib:$lib/crystal \
          --suffix CRYSTAL_LIBRARY_PATH : ${
            lib.makeLibraryPath (commonBuildInputs extraBuildInputs)
          }
        install -dm755 $lib/crystal
        cp -r src/* $lib/crystal/

        install -dm755 $out/share/doc/crystal/api
        cp -r docs/* $out/share/doc/crystal/api/
        cp -r samples $out/share/doc/crystal/

        install -Dm644 etc/completion.bash $out/share/bash-completion/completions/crystal
        install -Dm644 etc/completion.zsh $out/share/zsh/site-functions/_crystal

        install -Dm644 man/crystal.1 $out/share/man/man1/crystal.1

        install -Dm644 -t $out/share/licenses/crystal LICENSE README.md

        mkdir -p $out
        ln -s $bin/bin $out/bin
        ln -s $lib $out/lib

        runHook postInstall
      '';

      enableParallelBuilding = true;

      dontStrip = true;

      checkTarget = "compiler_spec";

      preCheck = ''
        export HOME=/tmp
        mkdir -p $HOME/test

        export LIBRARY_PATH=${lib.makeLibraryPath checkInputs}:$LIBRARY_PATH
        export PATH=${lib.makeBinPath checkInputs}:$PATH
      '';

      passthru.buildCrystalPackage = callPackage ./build-package.nix {
        crystal = compiler;
      };

      meta = with lib; {
        description = "A compiled language with Ruby like syntax and type inference";
        homepage = "https://crystal-lang.org/";
        license = licenses.asl20;
        maintainers = with maintainers; [ david50407 fabianhjr manveru peterhoeg ];
        platforms = builtins.attrNames archs;
        # Error running at_exit handler: Nil assertion failed
        broken = lib.versions.minor version == "32" && stdenv.isDarwin;
      };
    })
  );

in
rec {
  binaryCrystal_0_31 = genericBinary {
    version = "0.31.1";
    sha256s = {
      x86_64-linux = "0r8salf572xrnr4m6ll9q5hz6jj8q7ff1rljlhmqb1r26a8mi2ih";
      i686-linux = "0hridnis5vvrswflx0q67xfg5hryhz6ivlwrb9n4pryj5d1gwjrr";
      x86_64-darwin = "1dgxgv0s3swkc5cwawzgpbc6bcd2nx4hjxc7iw2h907y1vgmbipz";
    };
  };

  crystal_0_31 = generic {
    version = "0.31.1";
    sha256 = "1dswxa32w16gnc6yjym12xj7ibg0g6zk3ngvl76lwdjqb1h6lwz8";
    doCheck = false; # 5 checks are failing now
    binary = binaryCrystal_0_31;
  };

  crystal_0_32 = generic {
    version = "0.32.1";
    sha256 = "120ndi3nhh2r52hjvhwfb49cdggr1bzdq6b8xg7irzavhjinfza6";
    binary = crystal_0_31;
  };

  crystal_0_33 = generic {
    version = "0.33.0";
    sha256 = "1zg0qixcws81s083wrh54hp83ng2pa8iyyafaha55mzrh8293jbi";
    binary = crystal_0_32;
  };

  crystal_0_34 = generic {
    version = "0.34.0";
    sha256 = "110lfpxk9jnqyznbfnilys65ixj5sdmy8pvvnlhqhc3ccvrlnmq4";
    binary = crystal_0_33;
  };

  crystal_0_35 = generic {
    version = "0.35.1";
    sha256 = "0p51bjl1nsvwsm64lqq421dcsxa201w7wwq8plw4r8wqarpq0g69";
    binary = crystal_0_34;
    # Needs git to build as per https://github.com/crystal-lang/crystal/issues/9789
    extraBuildInputs = [ git ];
  };

  crystal_0_36 = generic {
    version = "0.36.1";
    sha256 = "sha256-5rjrvwZKM4lHpmxLyUVbi0Zw98xT+iJKonxwfUwS/Wk=";
    binary = crystal_0_35;
  };

  crystal_1_0 = generic {
    version = "1.0.0";
    sha256 = "sha256-RI+a3w6Rr+uc5jRf7xw0tOenR+q6qii/ewWfID6dbQ8=";
    binary = crystal_0_36;
  };

  crystal = crystal_1_0;

  crystal2nix = callPackage ./crystal2nix.nix { };
}
