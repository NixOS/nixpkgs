{ lib
, buildPythonPackage
, fetchPypi
, appdirs
, requests
, pytest
}:

buildPythonPackage rec {
  pname = "pipdate";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "26bd12075e63ef7f8094da36c27bf5539d298f4ef2af6acba20e98b502439d6d";
  };

  propagatedBuildInputs = [
    appdirs
    requests
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    HOME=$(mktemp -d) pytest test/test_pipdate.py
  '';

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "pip update helpers";
    homepage = https://github.com/nschloe/pipdate;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
