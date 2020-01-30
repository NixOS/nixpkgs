{ stdenv, lib, fetchFromGitHub, fetchurl, makeWrapper
, coreutils, git, gmp, nettools, openssl_1_0_2, readline, tzdata, libxml2, libyaml
, boehmgc, libatomic_ops, pcre, libevent, libiconv, llvm, clang, which, zlib, pkgconfig
, callPackage }:

# We need multiple binaries as a given binary isn't always able to build
# (even slightly) older or newer versions.
# - 0.26.1 can build 0.25.x and 0.26.x but not 0.27.x
# - 0.27.2 can build 0.27.x but not 0.25.x, 0.26.x and 0.29.x
#
# We need to keep around at least the latest version released with a stable
# NixOS

let
  archs = {
    x86_64-linux  = "linux-x86_64";
    i686-linux    = "linux-i686";
    x86_64-darwin = "darwin-x86_64";
  };

  arch = archs.${stdenv.system} or (throw "system ${stdenv.system} not supported");

  checkInputs = [ git gmp openssl_1_0_2 readline libxml2 libyaml ];

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
    boehmgc libatomic_ops pcre libevent libyaml zlib libxml2 openssl_1_0_2
  ] ++ extraBuildInputs
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv ];


  generic = ({ version, sha256, binary, doCheck ? true, extraBuildInputs ? [] }:
  lib.fix (compiler: stdenv.mkDerivation {
    pname = "crystal";
    inherit doCheck version;

    src = fetchFromGitHub {
      owner  = "crystal-lang";
      repo   = "crystal";
      rev    = version;
      inherit sha256;
    };

    outputs = [ "out" "lib" "bin" ];

    postPatch = ''
      substituteInPlace src/crystal/system/unix/time.cr \
        --replace /usr/share/zoneinfo ${tzdata}/share/zoneinfo

      ln -s spec/compiler spec/std

      mkdir /tmp/crystal
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
        --replace '`hostname`' '`${nettools}/bin/hostname`'

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

    nativeBuildInputs = [ binary makeWrapper which pkgconfig llvm ];

    makeFlags = [
      "CRYSTAL_CONFIG_VERSION=${version}"
    ];

    buildFlags = [
      "all" "docs"
    ];

    FLAGS = [
      "--release"
      "--single-module" # needed for deterministic builds
    ];

    # This makes sure we don't keep depending on the previous version of
    # crystal used to build this one.
    CRYSTAL_LIBRARY_PATH = "${placeholder "lib"}/crystal";

    # We *have* to add `which` to the PATH or crystal is unable to build stuff
    # later if which is not available.
    installPhase = ''
      runHook preInstall

      install -Dm755 .build/crystal $bin/bin/crystal
      wrapProgram $bin/bin/crystal \
          --suffix PATH : ${lib.makeBinPath [ pkgconfig clang which ]} \
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

    checkTarget = "spec";

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
      homepage = https://crystal-lang.org/;
      license = licenses.asl20;
      maintainers = with maintainers; [ manveru david50407 peterhoeg ];
      platforms = builtins.attrNames archs;
    };
  }));

in rec {
  binaryCrystal_0_26 = genericBinary {
    version = "0.26.1";
    sha256s = {
      x86_64-linux  = "1xban102yiiwmlklxvn3xp3q546bp8hlxxpakayajkhhnpl6yv45";
      i686-linux    = "1igspf1lrv7wpmz0pfrkbx8m1ykvnv4zhic53cav4nicppm2v0ic";
      x86_64-darwin = "1mri8bfrcldl69gczxpihxpv1shn4bijx28m3qby8vnk0ii63n9s";
    };
  };

  binaryCrystal_0_27 = genericBinary {
    version = "0.27.2";
    sha256s = {
      x86_64-linux  = "05l5x7kx2acgnv42fj3rr17z73ix06zvi05h7d7vf3kw0izxrasm";
      i686-linux    = "1iwizkvn6pglc0azkyfhlmk9ap793krdgcnbihd1kvrvs4cz0mm9";
      x86_64-darwin = "14c69ac2dmfwmb5q56ps3xyxxb0mrbc91ahk9h07c8fiqfii3k9g";
    };
  };

  binaryCrystal_0_29 = genericBinary {
    version = "0.29.0";
    sha256s = {
      x86_64-linux  = "1wrk29sfx35akg7hxwpdiikvl18wd40gq1kwirw7x522hnq7vlna";
      i686-linux    = "1nx0piis2k3nn7kqiijqazzbvlaavhgvsln0l3dxmpfa4i4dz5h2";
      x86_64-darwin = "1fd0fbyf05abivnp3igjlrm2axf65n2wdmg4aq6nqj60ipc01rvd";
    };
  };

  binaryCrystal_0_30 = genericBinary {
    version = "0.30.1";
    sha256s = {
      x86_64-linux  = "1k2mb74jh3ns3m7y73j4wpf571sayn73zbn6d7q81d09r280zrma";
      i686-linux    = "0vsq1ayf922spydp2g2mmimc797jmm7nl5nljhfppcclrwygdyk2";
      x86_64-darwin = "1p3s4lwdgykb7h7aysjhrs7vm0zhinzw5d7rfv6jsyin4j8yxhzz";
    };
  };

  binaryCrystal_0_31 = genericBinary {
    version = "0.31.1";
    sha256s = {
      x86_64-linux  = "0r8salf572xrnr4m6ll9q5hz6jj8q7ff1rljlhmqb1r26a8mi2ih";
      i686-linux    = "0hridnis5vvrswflx0q67xfg5hryhz6ivlwrb9n4pryj5d1gwjrr";
      x86_64-darwin = "1dgxgv0s3swkc5cwawzgpbc6bcd2nx4hjxc7iw2h907y1vgmbipz";
    };
  };

  crystal_0_25 = generic {
    version = "0.25.1";
    sha256  = "15xmbkalsdk9qpc6wfpkly3sifgw6a4ai5jzlv78dh3jp7glmgyl";
    doCheck = false;
    binary = binaryCrystal_0_26;
  };

  crystal_0_26 = generic {
    version = "0.26.1";
    sha256  = "0jwxrqm99zcjj82gyl6bzvnfj79nwzqf8sa1q3f66q9p50v44f84";
    doCheck = false; # about 20 tests out of more than 14000 are failing
    binary = binaryCrystal_0_26;
  };

  crystal_0_27 = generic {
    version = "0.27.2";
    sha256  = "0vxqnpqi85yh0167nrkbksxsni476iwbh6y3znbvbjbbfhsi3nsj";
    doCheck = false; # about 20 tests out of more than 15000 are failing
    binary = binaryCrystal_0_27;
  };

  crystal_0_29 = generic {
    version = "0.29.0";
    sha256  = "0v9l253b2x8yw6a43vvalywpwciwr094l3g5wakmndfrzak2s3zr";
    doCheck = false; # 6 checks are failing now
    binary = binaryCrystal_0_29;
  };

  crystal_0_30 = generic {
    version = "0.30.1";
    sha256  = "0fbk784zjflsl3hys5a1xmn8mda8kb2z7ql58wpyfavivswxanbs";
    doCheck = false; # 6 checks are failing now
    binary = binaryCrystal_0_29;
  };

  crystal_0_31 = generic {
    version = "0.31.1";
    sha256  = "1dswxa32w16gnc6yjym12xj7ibg0g6zk3ngvl76lwdjqb1h6lwz8";
    doCheck = false; # 5 checks are failing now
    binary = binaryCrystal_0_30;
  };

  crystal_0_32 = generic {
    version = "0.32.1";
    sha256  = "120ndi3nhh2r52hjvhwfb49cdggr1bzdq6b8xg7irzavhjinfza6";
    binary = binaryCrystal_0_31;
  };

  crystal = crystal_0_32;

  crystal2nix = callPackage ./crystal2nix.nix {};
}
