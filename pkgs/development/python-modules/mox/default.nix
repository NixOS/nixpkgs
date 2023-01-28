{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "mox";
  version = "0.7.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ivancrneto";
    repo = "pymox";
    rev = "v${version}";
    hash = "sha256-gODE9IGDk3WtO8iPOlp98fGp6Ih2laA3YlOHmq62m8Y=";
  };

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mox"
  ];

  meta = with lib; {
    description = "Mock object framework";
    homepage = "https://github.com/ivancrneto/pymox";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
