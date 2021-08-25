{ lib
, buildPythonPackage
, fetchPypi
, requests
, coverage
, unittest2
}:

buildPythonPackage rec {
  pname = "codecov";
  version = "2.1.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oNpGu1AlQm2ola+Qk43vjuEtN/y8u7wVttxkz368UcE=";
  };

  propagatedBuildInputs = [
    requests
    coverage
  ];

  checkInputs = [ unittest2 ];

  postPatch = ''
    sed -i 's/, "argparse"//' setup.py
  '';

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Python report uploader for Codecov";
    homepage = "https://codecov.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
