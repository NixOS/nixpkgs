{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  poetry-core,
  pyprojectVersionPatchHook,
  pytestCheckHook,

  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "fractional-indexing";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "httpie";
    repo = "fractional-indexing-python";
    tag = finalAttrs.version;
    hash = "sha256-R2ZdUSQnkmKbtn1SZRNNkWY9A/zECuOp03ikb4KB4DA=";
  };

  build-system = [
    poetry-core
    pyprojectVersionPatchHook
  ];

  # coverage is erroneously listed under [tool.poetry.dependencies] upstream
  pythonRemoveDeps = [ "coverage" ];

  pythonImportsCheck = [
    "fractional_indexing"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlags = [
    "tests.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python implementation of fractional indexing";
    homepage = "https://github.com/httpie/fractional-indexing-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phanirithvij ];
    # dependency for Karrot https://nlnet.nl/project/Karrot-UX/
    teams = with lib.teams; [ ngi ];
  };
})
