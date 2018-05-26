# Build a version of idris with a set of packages visible
# packages: The packages visible to idris
{ stdenv, idris, symlinkJoin, makeWrapper }: packages:

let paths = stdenv.lib.closePropagation packages;
in
symlinkJoin {

  name = idris.name + "-with-packages";

  paths = paths ++ [idris] ;

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/idris \
      --set IDRIS_LIBRARY_PATH $out/libs
      '';

}
