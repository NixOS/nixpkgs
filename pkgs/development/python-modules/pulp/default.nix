{ lib
, fetchPypi
, buildPythonPackage
, pyparsing
, amply
}:

buildPythonPackage rec {
  pname = "PuLP";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5dc7d76bfb1da06ac048066ced75603340d0d7ba8a7dbfce4040d6f126eda0d5";
  };

  propagatedBuildInputs = [ pyparsing amply ];

  # only one test that requires an extra
  doCheck = false;
  pythonImportsCheck = [ "pulp" ];

  meta = with lib; {
    homepage = "https://github.com/coin-or/pulp";
    description = "PuLP is an LP modeler written in python";
    maintainers = with maintainers; [ teto ];
    license = licenses.mit;
  };
}
