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
  version = "1.2.7-unstable-2023-10-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mclarkk";
    repo = "lifxlan";
    rev = "583df3defb1e3336151306428d0418599564a9ad";
    hash = "sha256-gEp56kYyyDXGdYeRxfn7uhJnRLnQLtPKPgd6WyuQX3g=";
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
