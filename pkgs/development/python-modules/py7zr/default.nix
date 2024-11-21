{
  lib,
  stdenv,
  black,
  brotli,
  brotlicffi,
  buildPythonPackage,
  check-manifest,
  coverage,
  coveralls,
  docutils,
  fetchFromGitHub,
  flake8,
  inflate64,
  isort,
  libarchive-c,
  lxml,
  multivolumefile,
  mypy,
  mypy-extensions,
  psutil,
  py-cpuinfo,
  pybcj,
  pycryptodomex,
  pygments,
  pyppmd,
  pytest,
  pytest-benchmark,
  pytest-cov-stub,
  pytest-leaks,
  pytest-profiling,
  pytest-remotedata,
  pytest-timeout,
  pytestCheckHook,
  python,
  pythonOlder,
  pyzstd,
  readme-renderer,
  setuptools,
  setuptools-scm,
  sphinx,
  sphinx-a4doc,
  sphinx-py3doc-enhanced-theme,
  texttable,
  twine,
  types-psutil,
}:

buildPythonPackage rec {
  pname = "py7zr";
  version = "0.22.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "miurahr";
    repo = "py7zr";
    rev = "refs/tags/v${version}";
    hash = "sha256-YR2cuHZWwqrytidAMbNvRV1/N4UZG8AMMmzcTcG9FvY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    (if python.isPyPy then brotlicffi else brotli)
    pycryptodomex
    texttable
    pyzstd
    pyppmd
    pybcj
    multivolumefile
    inflate64
  ] ++ lib.optional (!stdenv.hostPlatform.isCygwin) psutil;

  optional-dependencies = {
    check = [
      black
      check-manifest
      flake8
      isort
      lxml
      mypy
      mypy-extensions
      pygments
      readme-renderer
      twine
      types-psutil
    ];

    debug = [
      pytest
      pytest-leaks
      pytest-profiling
    ];

    docs = [
      docutils
      sphinx
      sphinx-a4doc
      sphinx-py3doc-enhanced-theme
    ];

    test = [
      pytest
      pytest-benchmark
      pytest-cov-stub
      pytest-remotedata
      pytest-timeout
      py-cpuinfo
      coverage
      coveralls
    ];

    test_compat = [ libarchive-c ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);

  # ValueError: 'int' is not callable
  doCheck = false;

  pythonImportsCheck = [ "py7zr" ];

  meta = {
    description = "7zip in python3 with ZStandard, PPMd, LZMA2, LZMA1, Delta, BCJ, BZip2, and Deflate compressions, and AES encryption";
    homepage = "https://github.com/miurahr/py7zr";
    changelog = "https://github.com/miurahr/py7zr/releases/tag/v${version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
