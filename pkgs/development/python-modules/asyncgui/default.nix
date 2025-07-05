{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  exceptiongroup,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "asyncgui";
  version = "0.8.0";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "asyncgui";
    repo = "asyncgui";
    rev = version;
    hash = "sha256-w5bsctUrNuPJSfz2yeYQPQg9KtfjKS68ixygsnQlB6w=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  dependencies = [
    exceptiongroup
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "asyncgui" ];

  meta = with lib; {
    description = "A minimalistic async library that focuses on fast responsiveness";
    homepage = "https://asyncgui.github.io/asyncgui";
    license = licenses.mit;
    maintainers = with maintainers; [ iofq ];
  };
}
