{ stdenv, fetchurl, fetchgit, gambit, openssl, zlib, coreutils, rsync, bash }:

stdenv.mkDerivation rec {
  name    = "gerbil-${version}";

  version = "0.10";
  src = fetchurl {
    url    = "https://github.com/vyzo/gerbil/archive/v${version}.tar.gz";
    sha256 = "14wzdnifr99g1mvm2xwks97nhaq62hfx43pxcw9gs647i7cymbly";
  };

  #version = "v0.7-49-g767926d";
  #src = fetchgit {
  #  url = "https://github.com/vyzo/gerbil.git";
  #  rev = "767926d7d6dde7e717cc51307f07e21859c79989";
  #  sha256 = "089lzsjmb43nns70pvn3kqg1gx6alsarbphvmh2a6qimnscdgv5z";
  #};
  # src = /home/fare/src/scheme/gerbil ;

  buildInputs = [ gambit openssl zlib coreutils rsync ];

  patchPhase = ''
    SCRIPTS=(
      src/*.sh
      src/gerbil/gx?
      src/gerbil/runtime/build.scm
      src/lang/build*ss
      src/std/build*.ss
      src/std/run-tests.ss
      src/std/web/fastcgi-test.ss
      src/std/web/rack-test.ss
      src/tutorial/lang/build.ss
    )
    for f in "''${SCRIPTS[@]}" ; do
      substituteInPlace "$f" --replace '#!/usr/bin/env bash' '#!${bash}/bin/bash'
      substituteInPlace "$f" --replace '#!/usr/bin/env gsi-script' '#!${gambit}/bin/gsi-script'
      substituteInPlace "$f" --replace '#!/usr/bin/env' '#!${coreutils}/bin/env'
    done
  '';

  buildPhase = ''
    ( cd src && sh build.sh )
  '';

  installPhase = ''
    ( mkdir -p $out/
      cp -fa bin lib etc doc $out/
      cd $out/bin
      for f in "''${SCRIPTS[@]}" ; do
        substituteInPlace gxc --replace "${coreutils}/bin/env gxi" "$out/bin/gxi"
      done
      ( echo '#!${bash}/bin/bash -e'
        echo "GERBIL_HOME=$out"
        echo 'export GERBIL_HOME'
        echo 'case "$1" in -:*) GSIOPTIONS=$1 ; shift ;; esac'
        echo 'if [[ $# = 0 ]] ; then '
        echo '  ${gambit}/bin/gsi $GSIOPTIONS $GERBIL_HOME/lib/gxi-init $GERBIL_HOME/lib/gxi-interactive - ;'
        echo 'else'
        echo '  ${gambit}/bin/gsi $GSIOPTIONS $GERBIL_HOME/lib/gxi-init "$@"'
        echo 'fi' ) > $out/bin/gxi
    )
  '';

  dontStrip = true;
  #dontFixup = true;

  meta = {
    description = "Gerbil";
    homepage    = "https://github.com/vyzo/gerbil";
    license     = stdenv.lib.licenses.lgpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ fare ];
  };
}
