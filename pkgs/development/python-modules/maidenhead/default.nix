{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "maidenhead";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "space-physics";
    repo = "maidenhead";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rUZ/O8FJfJ/6Ck86HDTPFq2yjuu82NGR6IqWehHvG5c=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "maidenhead" ];

  meta = {
    description = "Simple, yet effective location hashing algorithm";
    homepage = "https://github.com/space-physics/maidenhead";
    changelog = "https://github.com/space-physics/maidenhead/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ robertjakub ];
  };
})
