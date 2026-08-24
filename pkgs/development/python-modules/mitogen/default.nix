{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "mitogen";
  version = "0.3.51";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitogen-hq";
    repo = "mitogen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IjU8JwXhq/2A46K7ta8TbLTK60F1enkK3YWEWCWDdx0=";
  };

  build-system = [ setuptools ];

  # Tests require network access and Docker support
  doCheck = false;

  pythonImportsCheck = [ "mitogen" ];

  meta = {
    description = "Python Library for writing distributed self-replicating programs";
    homepage = "https://github.com/mitogen-hq/mitogen";
    changelog = "https://github.com/mitogen-hq/mitogen/blob/${finalAttrs.src.tag}/docs/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
