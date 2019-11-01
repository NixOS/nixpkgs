{ lib
, buildPythonPackage
, fetchPypi
, appdirs
, requests
, pytest
}:

buildPythonPackage rec {
  pname = "pipdate";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a27f64d13269adfd8594582f5a62c9f2151b426e701afdfc3b4f4019527b4121";
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
