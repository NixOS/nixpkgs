{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pamqp,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioamqp";
  version = "0.15.0";
  pyproject = true;

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

  meta = {
    description = "AMQP implementation using asyncio";
    homepage = "https://github.com/polyconseil/aioamqp";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
