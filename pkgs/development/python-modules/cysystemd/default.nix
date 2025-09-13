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
  version = "1.6.3";
in
buildPythonPackage {
  pname = "cysystemd";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "cysystemd";
    tag = version;
    hash = "sha256-xumrQgoKfFeKdRQUIYXXiXEcNd76i4wo/EIDm8BN7oU=";
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
