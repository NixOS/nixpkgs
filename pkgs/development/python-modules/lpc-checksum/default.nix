{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  intelhex,
}:

buildPythonPackage (finalAttrs: {
  pname = "lpc-checksum";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "basilfx";
    repo = "lpc_checksum";
    rev = "v${finalAttrs.version}";
    hash = "sha256-POgV0BdkMLmdjBh/FToPPmJTAxsPASB7ZE32SqGGKHk=";
  };

  nativeBuildInputs = [
    poetry-core
    pytestCheckHook
  ];

  propagatedBuildInputs = [ intelhex ];

  pythonImportsCheck = [ "lpc_checksum" ];

  meta = {
    description = "Python script to calculate LPC firmware checksums";
    mainProgram = "lpc_checksum";
    homepage = "https://pypi.org/project/lpc-checksum/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ otavio ];
  };
})
