{ lib, buildPythonPackage, fetchPypi, pytest, pytestrunner, six, regex}:

buildPythonPackage rec {
  pname = "rebulk";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "025d191c11abf9174c6aff0006579624047d3371a654333c4bf7a4b421552cdc";
  };

  # Some kind of trickery with imports that doesn't work.
  doCheck = false;
  buildInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ six regex ];

  meta = with lib; {
    homepage = "https://github.com/Toilal/rebulk/";
    license = licenses.mit;
    description = "Advanced string matching from simple patterns";
  };
}
