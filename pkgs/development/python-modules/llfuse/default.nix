{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
<<<<<<< HEAD
, cython_3
=======
, cython
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fuse
, pkg-config
, pytestCheckHook
, python
<<<<<<< HEAD
, setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, which
}:

buildPythonPackage rec {
  pname = "llfuse";
<<<<<<< HEAD
  version = "1.5.0";

  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "1.4.2";

  disabled = pythonOlder "3.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "python-llfuse";
    repo = "python-llfuse";
<<<<<<< HEAD
    rev = "refs/tags/release-${version}";
    hash = "sha256-6/iW5eHmX6ODVPLFkOo3bN9yW8ixqy2MHwQ2r9FA0iI=";
  };

  nativeBuildInputs = [ cython_3 pkg-config setuptools ];
=======
    rev = "release-${version}";
    hash = "sha256-TnZnv439fLvg0WM96yx0dPSSz8Mrae6GDC9LiLFrgQ8=";
  };

  nativeBuildInputs = [ cython pkg-config ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    changelog = "https://github.com/python-llfuse/python-llfuse/raw/release-${version}/Changes.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor dotlambda ];
  };
}
