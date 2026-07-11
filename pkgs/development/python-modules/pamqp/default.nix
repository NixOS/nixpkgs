{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "4.0.1";
  pname = "pamqp";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "gmr";
    repo = "pamqp";
    tag = version;
    hash = "sha256-WKkiwisCfGRkNbw8WtXqNe4OqUiRgVfVL7o0oMdeFJw=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

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

  meta = {
    changelog = "https://github.com/gmr/pamqp/blob/${src.tag}/docs/changelog.md";
    description = "RabbitMQ Focused AMQP low-level library";
    homepage = "https://github.com/gmr/pamqp";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
