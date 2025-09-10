{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pythonOlder,
  rstcheck-core,
  sphinx,
  typer,
}:

buildPythonPackage rec {
  pname = "rstcheck";
  version = "6.2.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rstcheck";
    repo = "rstcheck";
    tag = "v${version}";
    hash = "sha256-ajevEHCsPvr5e4K8I5AfxFZ+Vo1quaGUKFIEB9Wlobc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    rstcheck-core
    typer
  ];

  optional-dependencies = {
    sphinx = [ sphinx ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rstcheck" ];

  preCheck = ''
    # The tests need to find and call the rstcheck executable
    export PATH="$PATH:$out/bin";
  '';

  meta = with lib; {
    description = "Checks syntax of reStructuredText and code blocks nested within it";
    homepage = "https://github.com/myint/rstcheck";
    changelog = "https://github.com/rstcheck/rstcheck/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ staccato ];
    mainProgram = "rstcheck";
  };
}
