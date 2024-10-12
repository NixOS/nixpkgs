{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "flexit-bacnet";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "piotrbulinski";
    repo = "flexit_bacnet";
    rev = "refs/tags/${version}";
    hash = "sha256-Cy/WHKtJoZWSFOs+9rBYSLqZTF/68WRM1HiYXDyb9KM=";
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
