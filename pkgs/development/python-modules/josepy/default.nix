{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "josepy";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "certbot";
    repo = "josepy";
    tag = "v${version}";
    hash = "sha256-gXXsipvlxLs/dc0rjnaKlR4lySDfDfpo0tcSVrOz9P4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    cryptography
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "josepy" ];

  meta = {
    changelog = "https://github.com/certbot/josepy/blob/${src.tag}/CHANGELOG.rst";
    description = "JOSE protocol implementation in Python";
    mainProgram = "jws";
    homepage = "https://github.com/certbot/josepy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
