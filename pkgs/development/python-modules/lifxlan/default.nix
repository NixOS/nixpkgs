{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  bitstring,
  ifaddr,
}:

buildPythonPackage {
  pname = "lifxlan";
  version = "1.2.8-unstable-2025-01-07";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mclarkk";
    repo = "lifxlan";
    rev = "c07e283b39fde170baf71f70f38c5b02ec7b09ab";
    hash = "sha256-FHVqNOjbi46Dfyu4OfQBKdiDWrUAWjuwhcLvkVqw6c8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bitstring
    ifaddr
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "lifxlan" ];

  meta = {
    description = "Access LIFX devices locally using the official LIFX LAN protocol";
    homepage = "https://github.com/mclarkk/lifxlan";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
