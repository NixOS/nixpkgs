{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyyaml,
  litex,
  liteiclink,
}:
buildPythonPackage rec {
  pname = "liteeth";
  version = "2025.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "enjoy-digital";
    repo = "liteeth";
    tag = version;
    hash = "sha256-BMkMvp0LlBelkExVJhJO/3aB53Klkmg6rDe1INgz4vM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyyaml
    litex
    liteiclink
  ];

  meta = {
    description = "Small footprint and configurable Ethernet core";
    homepage = "https://github.com/enjoy-digital/liteeth";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ RossComputerGuy ];
  };
}
