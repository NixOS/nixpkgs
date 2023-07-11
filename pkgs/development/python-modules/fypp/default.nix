{ lib, stdenv, fetchFromGitHub, buildPythonApplication }:

buildPythonApplication rec {
  pname = "fypp";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "aradi";
    repo = pname;
    rev = version;
    hash = "sha256-iog5Gdcd1F230Nl4JDrKoyYr8JualVgNZQzHLzd4xe8=";
  };

  meta = with lib; {
    description = "Python powered Fortran preprocessor";
    homepage = "https://github.com/aradi/fypp";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.sheepforce ];
  };
}
