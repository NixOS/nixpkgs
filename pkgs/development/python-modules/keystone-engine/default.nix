{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  keystone,
}:

buildPythonPackage (finalAttrs: {
  pname = "keystone-engine";
  version = "0.9.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-L3r2LasM5sJzLbtPMc+iGEqKFJ4oC5a5LrwNuExuUPU=";
  };

  build-system = [
    setuptools
  ];

  setupPyBuildFlags = lib.optionals stdenv.hostPlatform.isLinux [
    "--plat-name"
    "linux"
  ];

  preConfigure = ''
    substituteInPlace setup.py --replace \
      "libkeystone" "${keystone}/lib/libkeystone"
  '';

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "keystone" ];

  meta = {
    description = "Lightweight multi-platform, multi-architecture assembler framework";
    homepage = "https://github.com/keystone-engine/keystone";
    maintainers = with lib.maintainers; [ dump_stack ];
    license = lib.licenses.gpl2Only;
  };
})
