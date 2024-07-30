{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyheos";
  version = "0.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andrewsayre";
    repo = "pyheos";
    rev = "refs/tags/${version}";
    hash = "sha256-vz81FepXWcCdlY1v7ozp+/l+XpYb91mNmRiLKwjrC4A=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # accesses network
    "test_connect_timeout"
  ];

  pythonImportsCheck = [ "pyheos" ];

  meta = with lib; {
    changelog = "https://github.com/andrewsayre/pyheos/releases/tag/${version}";
    description = "Async python library for controlling HEOS devices through the HEOS CLI Protocol";
    homepage = "https://github.com/andrewsayre/pyheos";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
