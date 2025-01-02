{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  intelhex,
}:

buildPythonPackage rec {
  pname = "lpc-checksum";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "basilfx";
    repo = "lpc_checksum";
    rev = "v${version}";
    hash = "sha256-POgV0BdkMLmdjBh/FToPPmJTAxsPASB7ZE32SqGGKHk=";
  };

  nativeBuildInputs = [
    poetry-core
    pytestCheckHook
  ];

  propagatedBuildInputs = [ intelhex ];

  pythonImportsCheck = [ "lpc_checksum" ];

  meta = with lib; {
    description = "Python script to calculate LPC firmware checksums";
    mainProgram = "lpc_checksum";
    homepage = "https://pypi.org/project/lpc-checksum/";
    license = licenses.mit;
    maintainers = with maintainers; [ otavio ];
  };
}
