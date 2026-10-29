{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiooncue";
  version = "0.3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiooncue";
    tag = finalAttrs.version;
    hash = "sha256-0Cdt/rUsl4OMLUTSC8WJXEiwzrhyn7JJIcVE/55LlgU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"setuptools>=75.8.0"' ""
  '';

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Tests are out-dated
  doCheck = false;

  pythonImportsCheck = [ "aiooncue" ];

  meta = {
    description = "Module to interact with the Kohler Oncue API";
    homepage = "https://github.com/bdraco/aiooncue";
    changelog = "https://github.com/bdraco/aiooncue/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
