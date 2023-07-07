{ pkgs, gccStdenv, lib, coreutils,
  openssl, zlib, sqlite, libxml2, libyaml, libmysqlclient, lmdb, leveldb, postgresql,
  version, git-version,
  gambit-support,
  gambit ? pkgs.gambit, gambit-params ? pkgs.gambit-support.stable-params, src }:

# We use Gambit, that works 10x better with GCC than Clang. See ../gambit/build.nix
let stdenv = gccStdenv; in

stdenv.mkDerivation rec {
  pname = "gerbil";
  inherit version;
  inherit src;

  buildInputs_libraries = [ openssl zlib sqlite libxml2 libyaml libmysqlclient lmdb leveldb postgresql ];

  # TODO: either fix all of Gerbil's dependencies to provide static libraries,
  # or give up and delete all tentative support for static libraries.
  #buildInputs_staticLibraries = map makeStaticLibraries buildInputs_libraries;

  buildInputs = [ gambit ]
    ++ buildInputs_libraries; # ++ buildInputs_staticLibraries;

  env.NIX_CFLAGS_COMPILE = "-I${libmysqlclient}/include/mysql -L${libmysqlclient}/lib/mysql";

  postPatch = ''
    echo '(define (gerbil-version-string) "v${git-version}")' > src/gerbil/runtime/gx-version.scm ;
    patchShebangs . ;
    grep -Fl '#!/usr/bin/env' `find . -type f -executable` | while read f ; do
      substituteInPlace "$f" --replace '#!/usr/bin/env' '#!${coreutils}/bin/env' ;
    done ;
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
# LIBXML2=${makeStaticLibraries libxml2}/lib/libxml2.a # MISSING!
# YAML=${makeStaticLibraries libyaml}/lib/libyaml.a # MISSING!
# MYSQL=${makeStaticLibraries libmysqlclient}/lib/mariadb/libmariadb.a
# LMDB=${makeStaticLibraries lmdb}/lib/mysql/libmysqlclient_r.a # MISSING!
# LEVELDB=${makeStaticLibraries leveldb}/lib/libleveldb.a
# EOF

  configurePhase = ''
    (cd src && ./configure \
      --prefix=$out/gerbil \
      --with-gambit=${gambit}/gambit \
      --enable-libxml \
      --enable-libyaml \
      --enable-zlib \
      --enable-sqlite \
      --enable-mysql \
      --enable-lmdb \
      --enable-leveldb)
  '';

  buildPhase = ''
    runHook preBuild

    # gxprof testing uses $HOME/.cache/gerbil/gxc
    export HOME=$PWD
    export GERBIL_BUILD_CORES=$NIX_BUILD_CORES
    export GERBIL_GXC=$PWD/bin/gxc
    export GERBIL_BASE=$PWD
    export GERBIL_HOME=$PWD
    export GERBIL_PATH=$PWD/lib
    export PATH=$PWD/bin:$PATH
    ${gambit-support.export-gambopt gambit-params}

    # Build, replacing make by build.sh
    ( cd src && sh build.sh )

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/gerbil $out/bin
    (cd src; ./install)
    (cd $out/bin ; ln -s ../gerbil/bin/* .)
    runHook postInstall
  '';

  dontStrip = true;

  meta = {
    description = "Gerbil Scheme";
    homepage    = "https://github.com/vyzo/gerbil";
    license     = lib.licenses.lgpl21; # also asl20, like Gambit
    # NB regarding platforms: regularly tested on Linux, only occasionally on macOS.
    # Please report success and/or failure to fare.
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fare ];
  };
}
