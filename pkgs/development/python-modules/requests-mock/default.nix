{ lib
, buildPythonPackage
, fetchPypi
, fixtures
, purl
, pytestCheckHook
, python
, requests
, requests-futures
, six
, testtools
}:

buildPythonPackage rec {
  pname = "requests-mock";
  version = "1.11.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7xC1crSJpfKOCbcIaXIIxKOyuJ74Cp8BWENA6jV+w8Q=";
  };

  propagatedBuildInputs = [ requests six ];

  nativeCheckInputs = [
    fixtures
    purl
    pytestCheckHook
    requests-futures
    testtools
  ];

  meta = with lib; {
    description = "Mock out responses from the requests package";
    homepage = "https://requests-mock.readthedocs.io";
    changelog = "https://github.com/jamielennox/requests-mock/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
