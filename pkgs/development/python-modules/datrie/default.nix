{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, setuptools
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, cython
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "datrie";
  version = "0.8.2";
<<<<<<< HEAD
  format = "pyproject";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UlsI9jjVz2EV32zNgY5aASmM0jCy2skcj/LmSZ0Ydl0=";
  };

<<<<<<< HEAD
  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner", ' ""
  '';

  nativeBuildInputs = [
    setuptools
    wheel
    cython
  ];

  nativeCheckInputs = [
=======
  nativeBuildInputs = [
    cython
  ];

  buildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    hypothesis
    pytestCheckHook
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    substituteInPlace setup.py --replace '"pytest-runner", ' ""
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [ "datrie" ];

  meta = with lib; {
    description = "Super-fast, efficiently stored Trie for Python";
    homepage = "https://github.com/kmike/datrie";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ lewo ];
  };
}
