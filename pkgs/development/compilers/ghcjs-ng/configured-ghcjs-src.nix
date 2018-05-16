{ perl
, autoconf
, automake
, python3
, gcc
, cabal-install
, gmp
, runCommand

, ghc
, happy
, alex

, ghcjsSrc
}:

runCommand "configured-ghcjs-src" {
  buildInputs = [
    perl
    autoconf
    automake
    python3
    gcc
    ghc
    happy
    alex
    cabal-install
  ];
  inherit ghcjsSrc;
} ''
  export HOME=$(pwd)
  cp -r "$ghcjsSrc" "$out"
  chmod -R +w "$out"
  cd "$out"

  # TODO: Find a better way to avoid impure version numbers
  sed -i 's/RELEASE=NO/RELEASE=YES/' ghc/configure.ac

  # TODO: How to actually fix this?
  # Seems to work fine and produce the right files.
  touch ghc/includes/ghcautoconf.h

  patchShebangs .
  ./utils/makePackages.sh copy
''
