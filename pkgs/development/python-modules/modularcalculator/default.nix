{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  strct,
  pytestCheckHook,
  pyyaml,
  scipy,
}:

buildPythonPackage rec {
  pname = "modularcalculator";
  version = "1.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JordanL2";
    repo = "ModularCalculator";
    tag = version;
    hash = "sha256-ZgGuw/+/GtsKxGHjinDxNs/bZZG/Du3GA9/oe+YqKyQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  dependencies = [
    pyyaml
    scipy
    strct
  ];

  meta = {
    description = "Powerful modular calculator engine";
    homepage = "https://github.com/JordanL2/ModularCalculator";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Tommimon ];
  };
}
