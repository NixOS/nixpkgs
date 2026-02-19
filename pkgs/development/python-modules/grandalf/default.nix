{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyparsing,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "grandalf";
  version = "0.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bdcht";
    repo = "grandalf";
    rev = "v${version}";
    hash = "sha256-j2SvpQvDMfwoj2PAQSxzEIyIzzJ61Eb9wgetKyni6A4=";
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
