{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytedee-async";
  version = "0.2.22";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "pytedee_async";
    tag = "v${version}";
    hash = "sha256-bMIsyjXiruj8QdyDRiXwjRfgi6Oxlhk0B2vLn6jeCi0=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "pytedee_async" ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Module to interact with Tedee locks";
    homepage = "https://github.com/zweckj/pytedee_async";
    changelog = "https://github.com/zweckj/pytedee_async/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
