{
  lib,
  buildPythonPackage,
  fetchFromGitea,

  # dependencies
  pyserial,
  asyncserial,
  jinja2,
  migen,

  # tests
  unittestCheckHook,
  numpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "misoc";
  version = "0.12-unstable-2026-10-02";
  format = "setuptools";

  src = fetchFromGitea {
    domain = "git.m-labs.hk";
    owner = "M-Labs";
    repo = "misoc";
    rev = "8a909c8b638fbec584048d6929d0c577f6be182d";
    hash = "sha256-9/yKXGHhd3Ji/zIOlek0B2CrO/W09AuwNuDZOVuLOTI=";
  };

  dependencies = [
    pyserial
    asyncserial
    jinja2
    migen
  ];

  nativeCheckInputs = [
    unittestCheckHook
    numpy
  ];

  disabledTestFiles = [
    # Fails duea multiprocessing issue that's probably only relevant in the
    # Nix sandbox.
    "misoc/test/coaxpress/test_lineparser.py"
  ];
  preCheck = ''
    rm ${lib.join " " finalAttrs.disabledTestFiles}
  '';

  pythonImportsCheck = [ "misoc" ];

  meta = {
    description = "Original high performance and small footprint system-on-chip based on Migen";
    homepage = "https://github.com/m-labs/misoc";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
