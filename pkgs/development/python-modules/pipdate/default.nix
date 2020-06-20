{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, appdirs
, requests
, pytest
}:

buildPythonPackage rec {
  pname = "pipdate";
  version = "0.5.1";
  disabled = isPy27; # abandoned

  src = fetchPypi {
    inherit pname version;
    sha256 = "d10bd408e4b067a2a699badf87629a12838fa42ec74dc6140e64a09eb0dc28cf";
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
    homepage = "https://github.com/nschloe/pipdate";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
