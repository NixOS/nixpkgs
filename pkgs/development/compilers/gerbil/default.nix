{ stdenv, fetchurl, fetchgit, gambit,
  coreutils, rsync, bash,
  openssl, zlib, sqlite, libxml2, libyaml, libmysql, lmdb, leveldb }:

stdenv.mkDerivation rec {
  name    = "gerbil-${version}";

  version = "0.12-DEV";
  src = fetchgit {
    url = "https://github.com/vyzo/gerbil.git";
    rev = "3657b6e940ea248e0b312f276590e38ff68997e7";
    sha256 = "11ys7082ghkm4yikz4qxmv3jpxcr42jfi0jhjw1mpzbqdg6004w2";
  };

  buildInputs = [
    gambit openssl
    coreutils rsync bash
    zlib openssl zlib sqlite libxml2 libyaml libmysql lmdb leveldb
  ];

  postPatch = ''
    patchShebangs .

    find . -type f -executable -print0 | while IFS= read -r -d ''$'\0' f; do
      substituteInPlace "$f" --replace '#!/usr/bin/env' '#!${coreutils}/bin/env'
    done
  '';

  buildPhase = ''
    runHook preBuild

    # Enable all optional libraries
    substituteInPlace "src/std/build-features.ss" --replace '#f' '#t'

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
  ${gambit}/bin/gsi \$GSIOPTIONS \$GERBIL_HOME/lib/gxi-init \$GERBIL_HOME/lib/gxi-interactive - ;
else
  ${gambit}/bin/gsi \$GSIOPTIONS \$GERBIL_HOME/lib/gxi-init "\$@"
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
