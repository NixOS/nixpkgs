{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,
  wheel,

  # dependencies
  typing-extensions,

  # checks
  pytestCheckHook,
  pytest-mpl,
  pytest-subtests,
}:

buildPythonPackage rec {
  pname = "flexparser";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hgrecco";
    repo = "flexparser";
    rev = version;
    hash = "sha256-9ImG8uh1SZ+pAbqzWBkTVn+3EBAGzzdP8vqqP59IgIw=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mpl
    pytest-subtests
  ];

  pythonImportsCheck = [ "flexparser" ];

  meta = with lib; {
    description = "Parsing made fun ... using typing";
    homepage = "https://github.com/hgrecco/flexparser";
    changelog = "https://github.com/hgrecco/flexparser/blob/${src.rev}/CHANGES";
    license = licenses.bsd3;
    maintainers = with maintainers; [ doronbehar ];
  };
}
