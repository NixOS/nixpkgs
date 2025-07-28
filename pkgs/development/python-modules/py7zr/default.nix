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
  pytest-remotedata,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "py7zr";
  version = "0.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miurahr";
    repo = "py7zr";
    tag = "v${version}";
    hash = "sha256-YR2cuHZWwqrytidAMbNvRV1/N4UZG8AMMmzcTcG9FvY=";
  };

  postPatch =
    # Replace inaccessible mirror (qt.mirrors.tds.net):
    # upstream PR: https://github.com/miurahr/py7zr/pull/637
    ''
      substituteInPlace tests/test_concurrent.py \
        --replace-fail 'http://qt.mirrors.tds.net/qt/' 'https://download.qt.io/'
    '';

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
    pytest-remotedata
    pytest-timeout
    pytestCheckHook
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
