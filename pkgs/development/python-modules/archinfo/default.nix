{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "archinfo";
  version = "10.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "archinfo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YQngKafRCnz0oaGKKruA+VY2k1A/P3g8ouOyiZWvkGs=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "archinfo" ];

  meta = {
    description = "Classes with architecture-specific information";
    homepage = "https://github.com/angr/archinfo";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
})
