{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
<<<<<<< HEAD
, cython_3
, pkg-config
, setuptools
=======
, cython
, pkg-config
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fuse3
, trio
, python
, pytestCheckHook
, pytest-trio
, which
}:

buildPythonPackage rec {
  pname = "pyfuse3";
<<<<<<< HEAD
  version = "3.3.0";

  disabled = pythonOlder "3.8";

  format = "pyproject";
=======
  version = "3.2.2";

  disabled = pythonOlder "3.5";

  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "libfuse";
    repo = "pyfuse3";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-GLGuTFdTA16XnXKSBD7ET963a8xH9EG/JfPNu6/3DOg=";
=======
    hash = "sha256-Y9Haz3MMhTXkvYFOGNWJnoGNnvoK6wiQ+s3AwJhBD8Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pkg-config'" "'$(command -v $PKG_CONFIG)'"
  '';

  nativeBuildInputs = [
<<<<<<< HEAD
    cython_3
    pkg-config
    setuptools
=======
    cython
    pkg-config
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [ fuse3 ];

  propagatedBuildInputs = [ trio ];

  preBuild = ''
    ${python.pythonForBuild.interpreter} setup.py build_cython
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
    maintainers = with maintainers; [ nyanloutre dotlambda ];
<<<<<<< HEAD
    changelog = "https://github.com/libfuse/pyfuse3/blob/${version}/Changes.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
