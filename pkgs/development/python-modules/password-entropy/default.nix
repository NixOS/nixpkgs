{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "password-entropy";
  version = "1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alistratov";
    repo = "password-entropy-py";
    tag = version;
    hash = "sha256-w721Y/zRMH3fsU0XtaGSDoj1GKqOW/IOGUfimoq4r2E=";
  };

  build-system = [
    flit-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "data_password_entropy"
  ];

  meta = {
    description = "Calculate password strength";
    homepage = "https://github.com/alistratov/password-entropy-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
