{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest-asyncio,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage rec {
  pname = "pyheos";
  version = "1.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andrewsayre";
    repo = "pyheos";
    tag = version;
    hash = "sha256-waOeUAvQtx8klFVGnMHi6/OI2s6fxgVjB8aBlaKtklQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    # accesses network
    "test_connect_timeout"
  ];

  pythonImportsCheck = [ "pyheos" ];

  meta = {
    changelog = "https://github.com/andrewsayre/pyheos/releases/tag/${src.tag}";
    description = "Async python library for controlling HEOS devices through the HEOS CLI Protocol";
    homepage = "https://github.com/andrewsayre/pyheos";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
