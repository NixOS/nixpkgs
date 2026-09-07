{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  pyserial,
  asyncserial,
  jinja2,
  migen,

  # tests
  unittestCheckHook,
  numpy,
}:

buildPythonPackage {
  pname = "misoc";
  version = "0.12-unstable-2025-10-03";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "misoc";
    rev = "59043e979f78934f2c2f99ac417c65aa0c7be0b9";
    hash = "sha256-dXamAZkLdTC9UeZV6biipsZN4LHO+ZLoXV4LO+L7HTM=";
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

  pythonImportsCheck = [ "misoc" ];

  meta = {
    description = "Original high performance and small footprint system-on-chip based on Migen";
    homepage = "https://github.com/m-labs/misoc";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
