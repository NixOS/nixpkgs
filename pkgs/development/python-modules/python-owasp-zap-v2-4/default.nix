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
  version = "0.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "zaproxy";
    repo = "zap-api-python";
    tag = version;
    sha256 = "sha256-UG8+0jJwnywvuc68/9r10kKMqxNIOg5mIdPt2Fx2BZA=";
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
