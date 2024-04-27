{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "3.3.0";
  pname = "pamqp";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "gmr";
    repo = "pamqp";
    rev = version;
    hash = "sha256-0vjiPBLd8afnATjmV2sINsBd4j7L544u5DA3jLiLSsY=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/gmr/pamqp/blob/${src.rev}/docs/changelog.rst";
    description = "RabbitMQ Focused AMQP low-level library";
    homepage = "https://github.com/gmr/pamqp";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
