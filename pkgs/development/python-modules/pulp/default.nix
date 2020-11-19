{ stdenv
, fetchPypi
, buildPythonPackage
, pyparsing
, amply
}:

buildPythonPackage rec {
  pname = "PuLP";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5bbe53f854fb3b689e4faacac5bdb5fa576cb270fc12c78edef827dd46a4fb50";
  };

  propagatedBuildInputs = [ pyparsing amply ];

  # only one test that requires an extra
  doCheck = false;
  pythonImportsCheck = [ "pulp" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/coin-or/pulp";
    description = "PuLP is an LP modeler written in python";
    maintainers = with maintainers; [ teto ];
    license = licenses.mit;
  };
}
