{ lib, stdenv, callPackage, clisp, fetchurl, fetchpatch, writeText, zstd
, threadSupport ? (stdenv.hostPlatform.isx86 || "aarch64-linux" == stdenv.hostPlatform.system || "aarch64-darwin" == stdenv.hostPlatform.system)
, linkableRuntime ? stdenv.hostPlatform.isx86
, disableImmobileSpace ? false
  # Meant for sbcl used for creating binaries portable to non-NixOS via save-lisp-and-die.
  # Note that the created binaries still need `patchelf --set-interpreter ...`
  # to get rid of ${glibc} dependency.
, purgeNixReferences ? false
, coreCompression ? lib.versionAtLeast version "2.2.6"
, texinfo
, version
}:

let
  versionMap = {
    # Only kept around for BCLM. Remove once unneeded there.
    "2.1.9" = {
      sha256 = "189gjqzdz10xh3ybiy4ch1r98bsmkcb4hpnrmggd4y2g5kqnyx4y";
    };

    "2.3.10" = {
      sha256 = "sha256-NYAzMV0H5MWmyDjufyLPxNSelISOtx7BOJ1JS8Mt0qs=";
    };
    "2.3.11" = {
      sha256 = "sha256-hL7rjXLIeJeEf8AoWtyz+k9IG9s5ECxPuat5aEGErSk=";
    };
  };
  # Collection of pre-built SBCL binaries for platforms that need them for
  # bootstrapping. Ideally these are to be avoided.  If CLISP (or any other
  # non-binary-distributed Lisp) can run on any of these systems, that entry
  # should be removed from this list.
  bootstrapBinaries = rec {
    # This build segfaults using CLISP.
    x86_64-darwin = {
      version = "2.2.9";
      system = "x86-64-darwin";
      sha256 = "sha256-b1BLkoLIOELAYBYA9eBmMgm1OxMxJewzNP96C9ADfKY=";
    };
    i686-linux = {
      version = "1.2.7";
      system = "x86-linux";
      sha256 = "07f3bz4br280qvn85i088vpzj9wcz8wmwrf665ypqx181pz2ai3j";
    };
    armv7l-linux = {
      version = "1.2.14";
      system = "armhf-linux";
      sha256 = "0sp5445rbvms6qvzhld0kwwvydw51vq5iaf4kdqsf2d9jvaz3yx5";
    };
    armv6l-linux = armv7l-linux;
    x86_64-freebsd = {
      version = "1.2.7";
      system = "x86-64-freebsd";
      sha256 = "14k42xiqd2rrim4pd5k5pjcrpkac09qnpynha8j1v4jngrvmw7y6";
    };
    x86_64-solaris = {
      version = "1.2.7";
      system = "x86-64-solaris";
      sha256 = "05c12fmac4ha72k1ckl6i780rckd7jh4g5s5hiic7fjxnf1kx8d0";
    };
  };
  sbclBootstrap = callPackage ./bootstrap.nix {
    cfg = bootstrapBinaries.${stdenv.hostPlatform.system};
  };
  bootstrapLisp =
    if (builtins.hasAttr stdenv.hostPlatform.system bootstrapBinaries)
    then "${sbclBootstrap}/bin/sbcl --disable-debugger --no-userinit --no-sysinit"
    else "${clisp}/bin/clisp -E UTF-8 --silent -norc";

in

stdenv.mkDerivation rec {
  pname = "sbcl";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/project/sbcl/sbcl/${version}/${pname}-${version}-source.tar.bz2";
    inherit (versionMap.${version}) sha256;
  };

  nativeBuildInputs = [ texinfo ];
  buildInputs = lib.optionals coreCompression [ zstd ];

  # There are no patches necessary for the currently enabled versions, but this
  # code is left in place for the next potential patch.
  postPatch = ''
    echo '"${version}.nixos"' > version.lisp-expr

    # SBCL checks whether files are up-to-date in many places..
    # Unfortunately, same timestamp is not good enough
    sed -e 's@> x y@>= x y@' -i contrib/sb-aclrepl/repl.lisp
    #sed -e '/(date)/i((= date 2208988801) 2208988800)' -i contrib/asdf/asdf.lisp
    sed -i src/cold/slam.lisp -e \
      '/file-write-date input/a)'
    sed -i src/cold/slam.lisp -e \
      '/file-write-date output/i(or (and (= 2208988801 (file-write-date output)) (= 2208988801 (file-write-date input)))'
    sed -i src/code/target-load.lisp -e \
      '/date defaulted-fasl/a)'
    sed -i src/code/target-load.lisp -e \
      '/date defaulted-source/i(or (and (= 2208988801 (file-write-date defaulted-source-truename)) (= 2208988801 (file-write-date defaulted-fasl-truename)))'

    # Fix the tests
    sed -e '5,$d' -i contrib/sb-bsd-sockets/tests.lisp
    sed -e '5,$d' -i contrib/sb-simple-streams/*test*.lisp
  ''
  + (if purgeNixReferences
    then
      # This is the default location to look for the core; by default in $out/lib/sbcl
      ''
        sed 's@^\(#define SBCL_HOME\) .*$@\1 "/no-such-path"@' \
          -i src/runtime/runtime.c
      ''
    else
      # Fix software version retrieval
      ''
        sed -e "s@/bin/uname@$(command -v uname)@g" -i src/code/*-os.lisp \
          src/code/run-program.lisp
      ''
    );


  preBuild = ''
    export INSTALL_ROOT=$out
    mkdir -p test-home
    export HOME=$PWD/test-home
  '';

  enableFeatures = with lib;
    optional threadSupport "sb-thread" ++
    optional linkableRuntime "sb-linkable-runtime" ++
    optional coreCompression "sb-core-compression" ++
    optional stdenv.isAarch32 "arm";

  disableFeatures = with lib;
    optional (!threadSupport) "sb-thread" ++
    optionals disableImmobileSpace [ "immobile-space" "immobile-code" "compact-instance-header" ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals (lib.versionOlder version "2.1.10") [
    # Workaround build failure on -fno-common toolchains like upstream
    # clang-13. Without the change build fails as:
    #   duplicate symbol '_static_code_space_free_pointer' in: alloc.o traceroot.o
    # Should be fixed past 2.1.10 release.
    "-fcommon"
  ]
    # Fails to find `O_LARGEFILE` otherwise.
    ++ [ "-D_GNU_SOURCE" ]);

  buildPhase = ''
    runHook preBuild

    sh make.sh --prefix=$out --xc-host="${bootstrapLisp}" ${
                  lib.concatStringsSep " "
                    (builtins.map (x: "--with-${x}") enableFeatures ++
                     builtins.map (x: "--without-${x}") disableFeatures)
                } ${lib.optionalString (stdenv.hostPlatform.system == "aarch64-darwin") "--arch=arm64"}
    (cd doc/manual ; make info)

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    INSTALL_ROOT=$out sh install.sh

    runHook postInstall
  ''
  + lib.optionalString (!purgeNixReferences) ''
    cp -r src $out/lib/sbcl
    cp -r contrib $out/lib/sbcl
    cat >$out/lib/sbcl/sbclrc <<EOF
     (setf (logical-pathname-translations "SYS")
       '(("SYS:SRC;**;*.*.*" #P"$out/lib/sbcl/src/**/*.*")
         ("SYS:CONTRIB;**;*.*.*" #P"$out/lib/sbcl/contrib/**/*.*")))
    EOF
  '';

  setupHook = lib.optional purgeNixReferences (writeText "setupHook.sh" ''
    addEnvHooks "$targetOffset" _setSbclHome
    _setSbclHome() {
      export SBCL_HOME='@out@/lib/sbcl/'
    }
  '');

  meta = with lib; {
    description = "Lisp compiler";
    homepage = "https://sbcl.org";
    license = licenses.publicDomain; # and FreeBSD
    maintainers = lib.teams.lisp.members;
    platforms = attrNames bootstrapBinaries ++ [
      # These aren’t bootstrapped using the binary distribution but compiled
      # using a separate (lisp) host
      "x86_64-linux"
      "aarch64-darwin"
      "aarch64-linux"
    ];
  };
}
