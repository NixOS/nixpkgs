{ stdenv
, buildPythonPackage
, substituteAll
, pkgs
}:

buildPythonPackage rec {
  pname = "gmsh";
  version = pkgs.gmsh.version;
  src = pkgs.gmsh.src;
  sourceRoot = "gmsh-${pkgs.gmsh.version}-source/api";

  patches = [
    ./add_setup.patch
    (substituteAll {
      src = ./fix_paths.patch;
      gmshdir = stdenv.lib.getLib pkgs.gmsh;
    })
  ];

  meta = {
    description = "Python API for Gmsh";
    homepage = pkgs.gmsh.meta.homepage;
    license = pkgs.gmsh.meta.license;
    maintainers = with stdenv.lib.maintainers; [ wulfsta ];
  };
}
