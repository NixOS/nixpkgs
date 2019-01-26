{ lib, symlinkJoin, makeWrapper, idris-no-deps, gcc, gmp }:

symlinkJoin {
  inherit (idris-no-deps) name src meta;
  paths = [ idris-no-deps ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/idris \
      --run 'export IDRIS_CC=''${IDRIS_CC:-${lib.getBin gcc}/bin/gcc}' \
      --suffix LIBRARY_PATH : ${lib.makeLibraryPath [ gmp ]}
  '';
}
