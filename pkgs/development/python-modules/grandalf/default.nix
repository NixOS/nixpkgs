{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyparsing,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "grandalf";
  version = "0.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdcht";
    repo = "grandalf";
    rev = "v${version}";
    hash = "sha256-oKuzk/vsEkoiEPgt/fsaaurKfz5CElXPEJe88aFBLqU=";
  };

  propagatedBuildInputs = [
    pyparsing
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  patches = [ ./no-setup-requires-pytestrunner.patch ];

  pythonImportsCheck = [ "grandalf" ];

  meta = with lib; {
    description = "Module for experimentations with graphs and drawing algorithms";
    homepage = "https://github.com/bdcht/grandalf";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
