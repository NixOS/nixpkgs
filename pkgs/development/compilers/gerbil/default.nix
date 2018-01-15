{ stdenv, fetchurl, fetchgit, gambit,
  coreutils, rsync, bash,
  openssl, zlib, sqlite, libxml2, libyaml, mysql, lmdb, leveldb }:

# TODO: distinct packages for gerbil-release and gerbil-devel

stdenv.mkDerivation rec {
  name    = "gerbil-${version}";

  version = "0.12-DEV-1030-gbbed3bc";
  src = fetchgit {
    url = "https://github.com/vyzo/gerbil.git";
    rev = "bbed3bc4cf7bcaa64eaabdf097192bfcc2bfc928";
    sha256 = "1dc0j143j860yq72lfjp71fin7hpsy1426azz7rl1szxvjfb7h4r";
  };

  buildInputs = [
    gambit
    coreutils rsync bash
    openssl zlib sqlite libxml2 libyaml mysql.connector-c lmdb leveldb
  ];

  NIX_CFLAGS_COMPILE = [ "-I${mysql.connector-c}/include/mysql" "-L${mysql.connector-c}/lib/mysql" ];

  postPatch = ''
    echo '(define (gerbil-version-string) "v${version}")' > src/gerbil/runtime/gx-version.scm

    patchShebangs .

    find . -type f -executable -print0 | while IFS= read -r -d ''$'\0' f; do
      substituteInPlace "$f" --replace '#!/usr/bin/env' '#!${coreutils}/bin/env'
    done
  '';

  buildPhase = ''
    runHook preBuild

    # Enable all optional libraries
    substituteInPlace "src/std/build-features.ss" --replace '#f' '#t'

    # gxprof testing uses $HOME/.cache/gerbil/gxc
    export HOME=$$PWD

    # Build, replacing make by build.sh
    ( cd src && sh build.sh )

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -fa bin lib etc doc $out/

    cat > $out/bin/gxi <<EOF
#!${bash}/bin/bash -e
export GERBIL_HOME=$out
case "\$1" in -:*) GSIOPTIONS=\$1 ; shift ;; esac
if [[ \$# = 0 ]] ; then
  exec ${gambit}/bin/gsi \$GSIOPTIONS \$GERBIL_HOME/lib/gxi-init \$GERBIL_HOME/lib/gxi-interactive - ;
else
  exec ${gambit}/bin/gsi \$GSIOPTIONS \$GERBIL_HOME/lib/gxi-init "\$@"
fi
EOF
    runHook postInstall
  '';

  dontStrip = true;

  meta = {
    description = "Gerbil Scheme";
    homepage    = "https://github.com/vyzo/gerbil";
    license     = stdenv.lib.licenses.lgpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ fare ];
  };
}
