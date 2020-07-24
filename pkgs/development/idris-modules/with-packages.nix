# Build a version of idris with a set of packages visible
# packages: The packages visible to idris
{ stdenv, idris, symlinkJoin, makeWrapper }: packages:

let paths = stdenv.lib.closePropagation packages;
in
stdenv.lib.appendToName "with-packages" (symlinkJoin {

  inherit (idris) name;

  paths = paths ++ [idris] ;

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/idris \
      --set IDRIS_LIBRARY_PATH $out/libs
  '';

})
