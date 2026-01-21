{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyparsing,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "grandalf";
  version = "0.55555";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bdcht";
    repo = "grandalf";
    tag = "v${version}";
    hash = "sha256-/kPGblngJRQWF+k6UZF4YRko1dKJPRuqCy8c3QpfA3E=";
  };

  propagatedBuildInputs = [
    pyparsing
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  patches = [ ./no-setup-requires-pytestrunner.patch ];

  pythonImportsCheck = [ "grandalf" ];

  meta = {
    description = "Module for experimentations with graphs and drawing algorithms";
    homepage = "https://github.com/bdcht/grandalf";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ cmcdragonkai ];
  };
}
