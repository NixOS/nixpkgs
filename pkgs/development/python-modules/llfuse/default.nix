{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, contextlib2
, cython
, fuse
, pkg-config
, pytestCheckHook
, python
, which
}:

buildPythonPackage rec {
  pname = "llfuse";
  version = "1.4.1";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "python-llfuse";
    repo = "python-llfuse";
    rev = "release-${version}";
    sha256 = "1dcpdg6cpkmdbyg66fgrylj7dp9zqzg5bf23y6m6673ykgxlv480";
  };

  nativeBuildInputs = [ cython pkg-config ];

  buildInputs = [ fuse ];

  propagatedBuildInputs = [ contextlib2 ];

  preBuild = ''
    ${python.interpreter} setup.py build_cython
  '';

  # On Darwin, the test requires macFUSE to be installed outside of Nix.
  doCheck = !stdenv.isDarwin;
  checkInputs = [ pytestCheckHook which ];

  disabledTests = [
    "test_listdir" # accesses /usr/bin
  ];

  meta = with lib; {
    description = "Python bindings for the low-level FUSE API";
    homepage = "https://github.com/python-llfuse/python-llfuse";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor dotlambda ];
  };
}
