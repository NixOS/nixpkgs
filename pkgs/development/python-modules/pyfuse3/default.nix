{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  pkg-config,
  setuptools,
  setuptools-scm,
  fuse3,
  trio,
  python,
  pytestCheckHook,
  pytest-trio,
  which,
}:

buildPythonPackage rec {
  pname = "pyfuse3";
  version = "3.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "libfuse";
    repo = "pyfuse3";
    tag = "v${version}";
    hash = "sha256-3mhtpXhia2w9VtdFctN+cGrvOmhRE3656fEciseY2u4=";
  };

  build-system = [
    cython
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fuse3 ];

  dependencies = [ trio ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-trio
    which
    fuse3
  ];

  # Checks if a /usr/bin directory exists, can't work on NixOS
  disabledTests = [ "test_listdir" ];

  pythonImportsCheck = [
    "pyfuse3"
    "pyfuse3.asyncio"
  ];

  meta = {
    description = "Python 3 bindings for libfuse 3 with async I/O support";
    homepage = "https://github.com/libfuse/pyfuse3";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [
      nyanloutre
      dotlambda
    ];
    changelog = "https://github.com/libfuse/pyfuse3/blob/${src.tag}/Changes.rst";
  };
}
