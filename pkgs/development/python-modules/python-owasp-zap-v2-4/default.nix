{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyhamcrest,
  pytestCheckHook,
  requests,
  requests-mock,
  six,
}:

buildPythonPackage rec {
  pname = "python-owasp-zap-v2-4";
<<<<<<< HEAD
  version = "0.5.0";
=======
  version = "0.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zaproxy";
    repo = "zap-api-python";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-8aZbnUoS9lrqM0XQg4PD/j1JFKzGh9dyzWF89Szdzao=";
=======
    hash = "sha256-UG8+0jJwnywvuc68/9r10kKMqxNIOg5mIdPt2Fx2BZA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ poetry-core ];

  dependencies = [
    requests
    six
  ];

  nativeCheckInputs = [
    pyhamcrest
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "zapv2" ];

<<<<<<< HEAD
  meta = {
    description = "Python library to access the OWASP ZAP API";
    homepage = "https://github.com/zaproxy/zap-api-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python library to access the OWASP ZAP API";
    homepage = "https://github.com/zaproxy/zap-api-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
