{ lib
, buildPythonPackage
, fetchPypi
, appdirs
, requests
, pytest
}:

buildPythonPackage rec {
  pname = "pipdate";
  version = "0.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "240c0f270ddb7470ad7b8c8fba4106e3dbd8817a370624fd8c32cf19155c9547";
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
