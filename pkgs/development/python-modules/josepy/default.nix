{
  lib,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  poetry-core,
  pyopenssl,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "josepy";
  version = "1.14.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MIs7+c6CWtTUu6djcs8ZtdwcLOlqnSmPlkKXXmS9E90=";
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
