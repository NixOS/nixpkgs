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
  version = "0.4.3-post1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "latexify_py";
    rev = "refs/tags/v${version}";
    hash = "sha256-4924pqgc+C8VDTTK5Dac6UJV0tcicVBdnkWvE1ynyvY=";
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
