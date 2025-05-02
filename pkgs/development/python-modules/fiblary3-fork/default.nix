{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, fixtures
, jsonpatch
, netaddr
, prettytable
, python-dateutil
, pytestCheckHook
, requests
, requests-mock
, six
, sphinx
, testtools
}:

buildPythonPackage rec {
  pname = "fiblary3-fork";
  version = "0.1.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "001wqh7gx2dv3sf7a5xsbppz9r88f5qwrp05jzjsjcm6cbcvmsz0";
  };

  propagatedBuildInputs = [
    jsonpatch
    netaddr
    prettytable
    python-dateutil
    requests
    six
  ];

  nativeCheckInputs = [
    fixtures
    pytestCheckHook
    requests-mock
    testtools
  ];

  pythonImportsCheck = [ "fiblary3" ];

  meta = with lib; {
    homepage = "https://github.com/graham33/fiblary";
    description = "Fibaro Home Center API Python Library";
    license = licenses.asl20;
    maintainers = with maintainers; [ graham33 ];
  };
}
