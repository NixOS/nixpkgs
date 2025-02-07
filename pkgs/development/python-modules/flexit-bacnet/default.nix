{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "flexit-bacnet";
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "piotrbulinski";
    repo = "flexit_bacnet";
    tag = version;
    hash = "sha256-c5561ewnAybYcdqesWYEgfT7Y+TetOjxLZeMTJ1ToUk=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "flexit_bacnet" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/piotrbulinski/flexit_bacnet/releases/tag/${version}";
    description = "Client BACnet library for Flexit Nordic series of air handling units";
    homepage = "https://github.com/piotrbulinski/flexit_bacnet";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
