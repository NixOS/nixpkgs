{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "losant-rest";
  version = "2.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Losant";
    repo = "losant-rest-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aIp1Rh91J78v6HoA8FPtI6xrr7Ld4sf1VRk/EP1Y5vg=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  enabledTestPaths = [ "tests/losant_rest_test.py" ];

  pythonImportsCheck = [ "losant_rest" ];

  meta = {
    description = "Python module for consuming the Losant IoT Platform API";
    homepage = "https://github.com/Losant/losant-rest-python";
    changelog = "https://github.com/Losant/losant-rest-python/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
