{ lib, stdenv, fetchFromGitHub, buildPythonApplication }:

buildPythonApplication rec {
  pname = "fypp";
  version = "3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aradi";
    repo = pname;
    rev = version;
    hash = "sha256-MgGVlOqOIrIVoDfBMVpFLT26mhYndxans2hfo/+jdoA=";
  };

  meta = with lib; {
    description = "Python powered Fortran preprocessor";
    homepage = "https://github.com/aradi/fypp";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.sheepforce ];
  };
}
