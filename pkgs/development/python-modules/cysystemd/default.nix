{
  lib,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  cython,
  pkg-config,
  setuptools,
}:

let
  version = "2.0.1";
in
buildPythonPackage {
  pname = "cysystemd";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "cysystemd";
    tag = version;
    hash = "sha256-K2SlTRPuFRvKUlWovWrS1BrbSBUF5FOI3aNC0FiCNfI=";
  };

  disabled = pythonOlder "3.6";

  build-system = [
    setuptools
    cython
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [ pkgs.systemd ];

  pythonImportsCheck = [ "cysystemd" ];

  meta = {
    description = "systemd wrapper on Cython";
    homepage = "https://github.com/mosquito/cysystemd";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
}
