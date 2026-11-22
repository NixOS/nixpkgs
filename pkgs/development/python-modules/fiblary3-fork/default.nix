{
  lib,
  buildPythonPackage,
  fetchPypi,
  fixtures,
  jsonpatch,
  netaddr,
  prettytable,
  python-dateutil,
  pytestCheckHook,
  requests,
  requests-mock,
  six,
  testtools,
}:

buildPythonPackage rec {
  pname = "fiblary3-fork";
  version = "0.1.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4Ou62WKmMqnllwXczHFxCOX07126F3WcHruJ/g7EPAA=";
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

  meta = {
    homepage = "https://github.com/graham33/fiblary";
    description = "Fibaro Home Center API Python Library";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ graham33 ];
  };
}
