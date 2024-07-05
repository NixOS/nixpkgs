{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flexparser";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hgrecco";
    repo = "flexparser";
    rev = "refs/tags/${version}";
    hash = "sha256-9ImG8uh1SZ+pAbqzWBkTVn+3EBAGzzdP8vqqP59IgIw=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flexparser" ];

  meta = {
    description = "Parsing made fun ... using typing";
    homepage = "https://github.com/hgrecco/flexparser";
    changelog = "https://github.com/hgrecco/flexparser/blob/${src.rev}/CHANGES";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
