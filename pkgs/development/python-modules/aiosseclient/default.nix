{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "aiosseclient";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ebraminio";
    repo = "aiosseclient";
    tag = version;
    hash = "sha256-ynWqRQsCuog8myNleJDdp+omyujmNB1Ys7O6gU2AaUc=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Test requires network access
  doCheck = false;

  pythonImportsCheck = [ "aiosseclient" ];

  meta = {
    description = "Asynchronous Server Side Events (SSE) client";
    homepage = "https://github.com/ebraminio/aiosseclient";
    changelog = "https://github.com/ebraminio/aiosseclient/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
