{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyhamcrest,
  pytestCheckHook,
  requests,
  requests-mock,
  six,
}:

buildPythonPackage rec {
  pname = "python-owasp-zap-v2-4";
  version = "0.0.18";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "zaproxy";
    repo = "zap-api-python";
    rev = version;
    sha256 = "0b46m9s0vwaaq8vhiqspdr2ns9qdw65fnjh8mf58gjinlsd27ygk";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  nativeCheckInputs = [
    pyhamcrest
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "zapv2" ];

  meta = with lib; {
    description = "Python library to access the OWASP ZAP API";
    homepage = "https://github.com/zaproxy/zap-api-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
