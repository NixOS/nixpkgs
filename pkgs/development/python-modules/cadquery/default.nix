{ lib
, buildPythonPackage
, fetchFromGitHub
, pyparsing
, opencascade_oce
, pythonocc-core
}:

buildPythonPackage rec {
  pname = "cadquery";
  version = "2.0RC0";

  src = fetchFromGitHub {
    owner = "CadQuery";
    repo = pname;
    rev = version;
    sha256 = "1s5arr8w1mn60isaf44diqf72vyscy5ihns3072h16ysbl0b509s";
  };

  buildInputs = [
    opencascade_oce
  ];

  propagatedBuildInputs = [
    pyparsing
    pythonocc-core
  ];

  meta = with lib; {
    description = "Parametric scripting language for creating and traversing CAD models";
    homepage = https://github.com/CadQuery/cadquery;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
