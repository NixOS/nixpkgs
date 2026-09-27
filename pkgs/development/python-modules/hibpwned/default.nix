{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "hibpwned";
  version = "1.3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plasticuproject";
    repo = "hibpwned";
    tag = finalAttrs.version;
    hash = "sha256-d3EhRu7HcvbyjWWHVSax0j39yE4+hJp8zvtyRKoh4sY=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Test require network access
  doCheck = false;

  pythonImportsCheck = [ "hibpwned" ];

  meta = {
    description = "Python API wrapper for haveibeenpwned.com";
    homepage = "https://github.com/plasticuproject/hibpwned";
    changelog = "https://github.com/plasticuproject/hibpwned/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
