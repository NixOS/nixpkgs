{
  brotli,
  brotlicffi,
  build,
  coverage,
  coveralls,
  buildPythonPackage,
  fetchPypi,
  inflate64,
  lib,
  multivolumefile,
  nix-update-script,
  psutil,
  py-cpuinfo,
  pybcj,
  pycryptodomex,
  pyppmd,
  pytest-benchmark,
  pytest-cov,
  pytest-httpserver,
  pytest-remotedata,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  pyzstd,
  requests,
  setuptools,
  setuptools-scm,
  texttable,
}:

buildPythonPackage rec {
  pname = "py7zr";
  version = "0.22.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xseupZE1NRhAA7c5OEkPmk2EGFmOUz+cqZHTuORaE54=";
  };

  build-system = [
    build
    setuptools
    setuptools-scm
  ];

  dependencies = [
    brotli
    brotlicffi
    inflate64
    multivolumefile
    psutil
    pybcj
    pycryptodomex
    pyppmd
    pyzstd
    texttable
  ];

  nativeCheckInputs = [
    coverage
    coveralls
    py-cpuinfo
    pytest-benchmark
    pytest-cov
    pytest-remotedata
    pytest-httpserver
    pytest-timeout
    pytestCheckHook
    requests
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://py7zr.readthedocs.io/en/latest/";
    description = "7zip archive compression, decompression, encryption and decryption";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.jwillikers ];
  };
}
