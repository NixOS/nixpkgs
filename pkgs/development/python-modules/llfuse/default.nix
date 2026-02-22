{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  fuse,
  pkg-config,
  pytestCheckHook,
  python,
  setuptools,
  which,
}:

buildPythonPackage rec {
  pname = "llfuse";
  version = "1.5.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-llfuse";
    repo = "python-llfuse";
    tag = "release-${version}";
    hash = "sha256-PFnY+gmm1tjZhptc27XTE9yxF0IaJ+U4Ng/OGhNDDPI=";
  };

  nativeBuildInputs = [
    cython
    pkg-config
    setuptools
  ];

  buildInputs = [ fuse ];

  preConfigure = ''
    substituteInPlace setup.py \
        --replace "'pkg-config'" "'${stdenv.cc.targetPrefix}pkg-config'"
  '';

  preBuild = ''
    ${python.pythonOnBuildForHost.interpreter} setup.py build_cython
  '';

  # On Darwin, the test requires macFUSE to be installed outside of Nix.
  doCheck = !stdenv.hostPlatform.isDarwin;
  nativeCheckInputs = [
    pytestCheckHook
    which
  ];

  disabledTests = [
    "test_listdir" # accesses /usr/bin
  ];

  meta = {
    description = "Python bindings for the low-level FUSE API";
    homepage = "https://github.com/python-llfuse/python-llfuse";
    changelog = "https://github.com/python-llfuse/python-llfuse/raw/release-${version}/Changes.rst";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      bjornfor
      dotlambda
    ];
  };
}
