{ symlinkJoin, makeWrapper, stdenv, gcc }: idris: { path, lib }:

symlinkJoin {
  name = idris.name;
  src = idris.src;
  paths = [ idris ];
  buildInputs = [ makeWrapper ];
  meta.platforms = idris.meta.platforms;
  postBuild = ''
    wrapProgram $out/bin/idris \
      --run 'export IDRIS_CC=''${IDRIS_CC:-${stdenv.lib.getBin gcc}/bin/gcc}' \
      --suffix PATH : ${ stdenv.lib.makeBinPath path } \
      --suffix LIBRARY_PATH : ${stdenv.lib.makeLibraryPath lib}
      '';
  }
