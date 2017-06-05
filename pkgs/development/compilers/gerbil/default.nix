{ stdenv, fetchurl, fetchgit, gambit, openssl, zlib, coreutils, rsync, bash }:

stdenv.mkDerivation rec {
  name    = "gerbil-${version}";

  version = "0.10";
  src = fetchurl {
    url    = "https://github.com/vyzo/gerbil/archive/v${version}.tar.gz";
    sha256 = "14wzdnifr99g1mvm2xwks97nhaq62hfx43pxcw9gs647i7cymbly";
  };

  buildInputs = [ gambit openssl zlib coreutils rsync bash ];

  postPatch = ''
    patchShebangs .

    find . -type f -executable -print0 | while IFS= read -r -d ''$'\0' f; do
      substituteInPlace "$f" --replace '#!/usr/bin/env' '#!${coreutils}/bin/env'
    done
  '';

  buildPhase = ''
    runHook preBuild
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
    description = "Gerbil";
    homepage    = "https://github.com/vyzo/gerbil";
    license     = stdenv.lib.licenses.lgpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ fare ];
  };
}
