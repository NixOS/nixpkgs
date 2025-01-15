{
  lib,
  buildPythonPackage,
  dill,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "latexify-py";
  version = "0.4.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "latexify_py";
    tag = "v${version}";
    hash = "sha256-tyBIOIVRSNrhO1NOD7Zqmiksrvrm42DUY4w1IocVRl4=";
  };

  build-system = [ hatchling ];

  dependencies = [ dill ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "latexify" ];

  preCheck = ''
    cd src
  '';

  meta = with lib; {
    description = "Generates LaTeX math description from Python functions";
    homepage = "https://github.com/google/latexify_py";
    changelog = "https://github.com/google/latexify_py/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ prusnak ];
  };
}
