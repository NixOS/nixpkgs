{
  lib,
  buildPythonPackage,
  fetchPypi,
  fixtures,
  mock,
  pbr,
  pytestCheckHook,
  pythonOlder,
  requests,
  testtools,
}:

buildPythonPackage rec {
  pname = "pyopnsense";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3DKlVrOtMa55gTu557pgojRpdgrO5pEZ3L+9gKoW9yg=";
  };

  propagatedBuildInputs = [
    pbr
    requests
  ];

  nativeCheckInputs = [
    fixtures
    mock
    pytestCheckHook
    testtools
  ];

  pythonImportsCheck = [ "pyopnsense" ];

  meta = {
    description = "Python client for the OPNsense API";
    homepage = "https://github.com/mtreinish/pyopnsense";
    changelog = "https://github.com/mtreinish/pyopnsense/releases/tag/${version}";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
