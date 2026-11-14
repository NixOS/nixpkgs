{
  lib,
  buildPythonPackage,
  dill,
  fetchFromGitHub,
  hatchling,
  pyprojectVersionPatchHook,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "latexify-py";
  version = "0.4.4";
  pyproject = true;

  # AttributeError: module 'ast' has no attribute 'Num'
  # https://docs.python.org/3/whatsnew/3.14.html#id9
  disabled = pythonAtLeast "3.14";

  src = fetchFromGitHub {
    owner = "google";
    repo = "latexify_py";
    tag = "v${version}";
    hash = "sha256-tyBIOIVRSNrhO1NOD7Zqmiksrvrm42DUY4w1IocVRl4=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [ dill ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "latexify" ];

  preCheck = ''
    cd src
  '';

  meta = {
    description = "Generates LaTeX math description from Python functions";
    homepage = "https://github.com/google/latexify_py";
    changelog = "https://github.com/google/latexify_py/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
