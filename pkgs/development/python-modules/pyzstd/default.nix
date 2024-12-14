{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pkgs,
  pypaInstallHook,
  setuptoolsBuildHook,
}:

buildPythonPackage rec {
  pname = "pyzstd";
  version = "0.16.2";
  # There is a pyproject.toml, but we want to dynamically link zstd, which can
  # only be done through a setup.py argument
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Rogdham";
    repo = "pyzstd";
    tag = version;
    hash = "sha256-Az+0m1XUFxExBZK8bcjK54Zt2d5ZlAKRMZRdr7rPcss=";
  };

  nativeBuildInputs = [
    pypaInstallHook
    setuptoolsBuildHook
  ];

  buildInputs = [ pkgs.zstd ];

  setupPyBuildFlags = [
    "--dynamic-link-zstd"
  ];

  pythonImportsCheck = [ "pyzstd" ];

  meta = {
    description = "Python bindings to Zstandard (zstd) compression library";
    homepage = "https://pyzstd.readthedocs.io";
    changelog = "https://github.com/Rogdham/pyzstd/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ PopeRigby ];
  };
}
