{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  poetry-core,
  pyopenssl,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "josepy";
  version = "1.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "certbot";
    repo = "josepy";
    tag = "v${version}";
    hash = "sha256-fK4JHDP9eKZf2WO+CqRdEjGwJg/WNLvoxiVrb5xQxRc=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    pyopenssl
    cryptography
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "josepy" ];

  meta = with lib; {
    changelog = "https://github.com/certbot/josepy/blob/v${version}/CHANGELOG.rst";
    description = "JOSE protocol implementation in Python";
    mainProgram = "jws";
    homepage = "https://github.com/certbot/josepy";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
