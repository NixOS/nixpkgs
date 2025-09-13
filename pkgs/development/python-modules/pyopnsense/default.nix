{
  lib,
  buildPythonPackage,
  fetchPypi,
  fixtures,
  mock,
  pbr,
  pytestCheckHook,
  requests,
  testtools,
}:

buildPythonPackage rec {
  pname = "pyopnsense";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3DKlVrOtMa55gTu557pgojRpdgrO5pEZ3L+9gKoW9yg=";
  };

  build-system = [ pbr ];

  dependencies = [
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
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
}
