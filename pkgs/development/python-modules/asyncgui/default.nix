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
  version = "0.9.3";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "asyncgui";
    repo = "asyncgui";
    rev = version;
    hash = "sha256-WeB7E9p3fVeMeuPsc20SFNDyo8oojZ6KcrXTQmOyFIU=";
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
