{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  cython,
  pkg-config,
  setuptools,
  fuse3,
  trio,
  python,
  pytestCheckHook,
  pytest-trio,
  which,
}:

buildPythonPackage rec {
  pname = "pyfuse3";
  version = "3.3.0";

  disabled = pythonOlder "3.8";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "libfuse";
    repo = "pyfuse3";
    rev = "refs/tags/${version}";
    hash = "sha256-GLGuTFdTA16XnXKSBD7ET963a8xH9EG/JfPNu6/3DOg=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pkg-config'" "'$(command -v $PKG_CONFIG)'"
  '';

  nativeBuildInputs = [
    cython
    pkg-config
    setuptools
  ];

  buildInputs = [ fuse3 ];

  propagatedBuildInputs = [ trio ];

  preBuild = ''
    ${python.pythonOnBuildForHost.interpreter} setup.py build_cython
  '';

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
    "pyfuse3_asyncio"
  ];

  meta = with lib; {
    description = "Python 3 bindings for libfuse 3 with async I/O support";
    homepage = "https://github.com/libfuse/pyfuse3";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [
      nyanloutre
      dotlambda
    ];
    changelog = "https://github.com/libfuse/pyfuse3/blob/${version}/Changes.rst";
  };
}
