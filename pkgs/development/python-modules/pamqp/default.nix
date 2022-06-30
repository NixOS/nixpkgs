{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "3.1.0";
  pname = "pamqp";

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gmr";
    repo = "pamqp";
    rev = version;
    hash = "sha256-qiYfQsyYvG6pyRFDt3pyYKNNWNP88maj+VAeGD68OmY=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pamqp.base"
    "pamqp.body"
    "pamqp.commands"
    "pamqp.common"
    "pamqp.decode"
    "pamqp.encode"
    "pamqp.exceptions"
    "pamqp.frame"
    "pamqp.header"
    "pamqp.heartbeat"
  ];

  meta = with lib; {
    description = "RabbitMQ Focused AMQP low-level library";
    homepage = "https://github.com/gmr/pamqp";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
