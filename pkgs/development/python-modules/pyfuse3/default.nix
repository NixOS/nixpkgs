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
  version = "3.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "libfuse";
    repo = "pyfuse3";
    tag = version;
    hash = "sha256-J4xHiaV8GCtUQ9GJS8YRXpMsuzuwbtnzspvuIonHT24=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "if DEVELOPER_MODE" "if False" \
      --replace-fail "'pkg-config'" "'$(command -v $PKG_CONFIG)'"
  '';

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fuse3 ];

  dependencies = [ trio ];

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
