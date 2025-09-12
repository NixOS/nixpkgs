{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  brotli,
  inflate64,
  multivolumefile,
  psutil,
  pybcj,
  pycryptodomex,
  pyppmd,
  pyzstd,
  texttable,
  py-cpuinfo,
  pytest-benchmark,
  pytest-httpserver,
  pytest-remotedata,
  pytest-timeout,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "py7zr";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miurahr";
    repo = "py7zr";
    tag = "v${version}";
    hash = "sha256-uV4zBQZlHfHgM/NiVSjI5I9wJRk9i4ihJn4B2R6XRuM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    brotli
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
    py-cpuinfo
    pytest-benchmark
    pytest-httpserver
    pytest-remotedata
    pytest-timeout
    pytestCheckHook
    requests
  ];

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [
    "py7zr"
  ];

  meta = {
    description = "7zip in Python 3 with ZStandard, PPMd, LZMA2, LZMA1, Delta, BCJ, BZip2";
    homepage = "https://github.com/miurahr/py7zr";
    changelog = "https://github.com/miurahr/py7zr/blob/v${version}/docs/Changelog.rst#v${
      builtins.replaceStrings [ "." ] [ "" ] version
    }";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      pitkling
      PopeRigby
    ];
  };
}
