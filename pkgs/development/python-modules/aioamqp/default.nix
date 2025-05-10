{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pamqp,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioamqp";
  version = "0.15.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Polyconseil";
    repo = "aioamqp";
    rev = "aioamqp-${version}";
    hash = "sha256-fssPknJn1tLtzb+2SFyZjfdhUdD8jqkwlInoi5uaplk=";
  };

  build-system = [ setuptools ];

  dependencies = [ pamqp ];

  # Tests assume rabbitmq server running
  doCheck = false;

  pythonImportsCheck = [ "aioamqp" ];

  meta = with lib; {
    description = "AMQP implementation using asyncio";
    homepage = "https://github.com/polyconseil/aioamqp";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
