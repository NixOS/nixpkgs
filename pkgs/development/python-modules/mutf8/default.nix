{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "mutf8";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TkTech";
    repo = "mutf8";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vtfdik+g2jnadslfthGXJWJidzR1BJibod10Wla6lSg=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkPhase = ''
    # Using pytestCheckHook results in test failures
    pytest
  '';

  pythonImportsCheck = [ "mutf8" ];

  meta = {
    description = "Fast MUTF-8 encoder & decoder";
    homepage = "https://github.com/TkTech/mutf8";
    changelog = "https://github.com/TkTech/mutf8/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
