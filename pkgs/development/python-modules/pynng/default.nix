{
  lib,
  cmake,
  ninja,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  cffi,
  sniffio,
  pytest,
  trio,
  pytest-trio,
  pytest-asyncio,
}:
let
  nng = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nng";
    tag = "v1.6.0";
    hash = "sha256-Kq8QxPU6SiTk0Ev2IJoktSPjVOlAS4/e1PQvw2+e8UA=";
  };

  mbedtls = fetchFromGitHub {
    owner = "ARMmbed";
    repo = "mbedtls";
    tag = "v3.5.1";
    hash = "sha256-HxsHcGbSExp1aG5yMR/J3kPL4zqnmNoN5T5wfV3APaw=";
  };

in
buildPythonPackage {
  pname = "pynng";
  version = "0.8.1-unstable-2025-05-14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "codypiersall";
    repo = "pynng";
    rev = "2179328f8a858bbb3e177f66ac132bde4a5aa859";
    hash = "sha256-TxIVcqc+4bro+krc1AWgLdZKGGuQ2D6kybHnv5z1oHg=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = "0.8.1";

  nativeBuildInputs = [
    cmake
    ninja
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  preBuild = ''
    cp -r ${mbedtls} mbedtls
    chmod -R +w mbedtls
    cp -r ${nng} nng
    chmod -R +w nng
  '';

  dontUseCmakeConfigure = true;

  dependencies = [
    cffi
    sniffio
    pytest
    trio
    pytest-trio
    pytest-asyncio
  ];

  pythonImportsCheck = [ "pynng" ];

  meta = {
    description = "Python bindings for Nanomsg Next Generation";
    homepage = "https://github.com/codypiersall/pynng";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ afermg ];
    platforms = lib.platforms.all;
  };
}
