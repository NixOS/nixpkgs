{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cython
, fuse
, pkg-config
, pytestCheckHook
, python
, setuptools
, which
}:

buildPythonPackage rec {
  pname = "llfuse";
  version = "1.4.4";

  format = "pyproject";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "python-llfuse";
    repo = "python-llfuse";
    rev = "refs/tags/release-${version}";
    hash = "sha256-qsnmhnZsK0j9dPhXT9mymQTzVHmmGnB5vgONatxDLIo=";
  };

  nativeBuildInputs = [ cython pkg-config setuptools ];

  buildInputs = [ fuse ];

  preConfigure = ''
    substituteInPlace setup.py \
        --replace "'pkg-config'" "'${stdenv.cc.targetPrefix}pkg-config'"
  '';

  preBuild = ''
    ${python.pythonForBuild.interpreter} setup.py build_cython
  '';

  # On Darwin, the test requires macFUSE to be installed outside of Nix.
  doCheck = !stdenv.isDarwin;
  nativeCheckInputs = [ pytestCheckHook which ];

  disabledTests = [
    "test_listdir" # accesses /usr/bin
  ];

  meta = with lib; {
    description = "Python bindings for the low-level FUSE API";
    homepage = "https://github.com/python-llfuse/python-llfuse";
    changelog = "https://github.com/python-llfuse/python-llfuse/raw/release-${version}/Changes.rst";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor dotlambda ];
  };
}
