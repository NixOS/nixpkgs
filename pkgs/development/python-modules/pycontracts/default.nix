{ stdenv, buildPythonPackage, fetchPypi
, nose, pyparsing, decorator, six }:

buildPythonPackage rec {
  pname = "PyContracts";
  version = "1.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e52c4ddbc015b56cc672b7c005c11f3df4fe407b832964099836fa3cccb8b9d";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ pyparsing decorator six ];

  meta = with stdenv.lib; {
    description = "Allows to declare constraints on function parameters and return values";
    homepage = https://pypi.python.org/pypi/PyContracts;
    license = licenses.lgpl2;
  };
}
