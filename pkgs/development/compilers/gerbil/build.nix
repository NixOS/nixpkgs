{ pkgs, gccStdenv, lib, coreutils,
  openssl, zlib, sqlite,
  version, git-version, src,
  gambit-support,
  gambit-git-version,
  gambit-stampYmd,
  gambit-stampHms,
  gambit-params }:

# We use Gambit, that works 10x better with GCC than Clang. See ../gambit/build.nix
let stdenv = gccStdenv; in

stdenv.mkDerivation rec {
  pname = "gerbil";
  inherit version;
  inherit src;

  buildInputs_libraries = [ openssl zlib sqlite ];

  # TODO: either fix all of Gerbil's dependencies to provide static libraries,
  # or give up and delete all tentative support for static libraries.
  #buildInputs_staticLibraries = map makeStaticLibraries buildInputs_libraries;

  buildInputs = buildInputs_libraries;

  postPatch = ''
    echo '(define (gerbil-version-string) "v${git-version}")' > src/gerbil/runtime/gx-version.scm ;
    patchShebangs . ;
    grep -Fl '#!/usr/bin/env' `find . -type f -executable` | while read f ; do
      substituteInPlace "$f" --replace '#!/usr/bin/env' '#!${coreutils}/bin/env' ;
    done ;
    substituteInPlace ./configure --replace 'set -e' 'set -e ; git () { echo "v${git-version}" ;}' ;
    substituteInPlace ./src/build/build-version.scm --replace "with-exception-catcher" '(lambda _ "v${git-version}")' ;
    #rmdir src/gambit
    #cp -a ${pkgs.gambit-unstable.src} ./src/gambit
    chmod -R u+w ./src/gambit
    ( cd src/gambit ; ${gambit-params.fixStamp gambit-git-version gambit-stampYmd gambit-stampHms} )
    for f in src/bootstrap/gerbil/compiler/driver__0.scm \
             src/build/build-libgerbil.ss \
             src/gerbil/compiler/driver.ss ; do
      substituteInPlace "$f" --replace '"gcc"' '"${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}gcc"' ;
    done
  '';

## TODO: make static compilation work.
## For that, get all the packages below to somehow expose static libraries,
## so we can offer users the option to statically link them into Gambit and/or Gerbil.
## Then add the following to the postPatch script above:
#     cat > etc/gerbil_static_libraries.sh <<EOF
# OPENSSL_LIBCRYPTO=${makeStaticLibraries openssl}/lib/libcrypto.a # MISSING!
# OPENSSL_LIBSSL=${makeStaticLibraries openssl}/lib/libssl.a # MISSING!
# ZLIB=${makeStaticLibraries zlib}/lib/libz.a
# SQLITE=${makeStaticLibraries sqlite}/lib/sqlite.a # MISSING!
# EOF

  configureFlags = [
    "--prefix=$out/gerbil"
    "--enable-zlib"
    "--enable-sqlite"
    "--enable-shared"
    "--disable-deprecated"
    "--enable-march=" # Avoid non-portable invalid instructions
  ];

  configurePhase = ''
    export CC=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}gcc \
           CXX=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}g++ \
           CPP=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}cpp \
           CXXCPP=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}cpp \
           LD=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}ld \
           XMKMF=${coreutils}/bin/false
    unset CFLAGS LDFLAGS LIBS CPPFLAGS CXXFLAGS
    (cd src/gambit ; ${gambit-params.fixStamp gambit-git-version gambit-stampYmd gambit-stampHms})
    ./configure ${builtins.concatStringsSep " " configureFlags}
    (cd src/gambit ;
    substituteInPlace config.status \
      ${lib.optionalString (gccStdenv.isDarwin && !gambit-params.stable)
         ''--replace "/usr/local/opt/openssl@1.1" "${lib.getLib openssl}"''} \
        --replace "/usr/local/opt/openssl" "${lib.getLib openssl}"
    ./config.status
    )
  '';

  extraLdOptions = [
      "-L${zlib}/lib"
      "-L${openssl.out}/lib"
      "-L${sqlite.out}/lib"
    ];

  buildPhase = ''
    runHook preBuild

    # gxprof testing uses $HOME/.cache/gerbil/gxc
    export HOME=$PWD
    export GERBIL_BUILD_CORES=$NIX_BUILD_CORES
    export GERBIL_GXC=$PWD/bin/gxc
    export GERBIL_BASE=$PWD
    export GERBIL_PREFIX=$PWD
    export GERBIL_PATH=$PWD/lib
    export PATH=$PWD/bin:$PATH
    ${gambit-support.export-gambopt gambit-params}

    # Build, replacing make by build.sh
    ( cd src && sh build.sh )

    f=build/lib/libgerbil.so.ldd ; [ -f $f ] && :
    substituteInPlace "$f" --replace '(' \
      '(${lib.strings.concatStrings (map (x: "\"${x}\" " ) extraLdOptions)}'

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/gerbil $out/bin
    ./install.sh
    (cd $out/bin ; ln -s ../gerbil/bin/* .)
    runHook postInstall
  '';

  dontStrip = true;

  meta = {
    description = "Gerbil Scheme";
    homepage    = "https://github.com/vyzo/gerbil";
    license     = lib.licenses.lgpl21Only; # dual, also asl20, like Gambit
    # NB regarding platforms: regularly tested on Linux and on macOS.
    # Please report success and/or failure to fare.
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fare ];
  };

  outputsToInstall = [ "out" ];
}
