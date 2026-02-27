{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyyaml,
  litex,
}:
buildPythonPackage rec {
  pname = "litesdcard";
  version = "2025.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "enjoy-digital";
    repo = "litesdcard";
    tag = version;
    hash = "sha256-ELIvG3sX2BQPLRuQx2LJYqnv0EYO102YoHbd0w9t+i8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyyaml
    litex
  ];

  meta = {
    description = "Small footprint and configurable SDcard core";
    homepage = "https://github.com/enjoy-digital/litesdcard";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ RossComputerGuy ];
  };
}
