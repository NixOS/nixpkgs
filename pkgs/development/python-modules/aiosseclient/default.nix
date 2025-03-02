{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiosseclient";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ebraminio";
    repo = "aiosseclient";
    rev = version;
    hash = "sha256-T97HmO53w1zNpASPU+LRcnqtnQVqPWtlOXycpBw4WmY=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  doCheck = false; # requires network access

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiosseclient" ];

  meta = {
    description = "Asynchronous Server Side Events (SSE) client for Python 3";
    homepage = "https://github.com/ebraminio/aiosseclient/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
