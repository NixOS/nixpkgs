<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
=======
{ buildPythonPackage
, fetchPypi
, lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, msgpack
, greenlet
, pythonOlder
, isPyPy
<<<<<<< HEAD
=======
, pytest-runner
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pynvim";
  version = "0.4.3";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  disabled = pythonOlder "3.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OnlTeL3l6AkvvrOhqZvpxhPSaFVC8dsOXG/UZ+7Vbf8=";
  };

<<<<<<< HEAD
  postPatch = ''
    substituteInPlace setup.py \
      --replace " + pytest_runner" ""
  '';

  propagatedBuildInputs = [
    msgpack
  ] ++ lib.optionals (!isPyPy) [
    greenlet
  ];

  # Tests require pkgs.neovim which we cannot add because of circular dependency
  doCheck = false;

  pythonImportsCheck = [
    "pynvim"
  ];

  meta = with lib; {
    description = "Python client for Neovim";
    homepage = "https://github.com/neovim/pynvim";
    changelog = "https://github.com/neovim/pynvim/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
=======
  nativeBuildInputs = [
    pytest-runner
  ];

  # Tests require pkgs.neovim,
  # which we cannot add because of circular dependency.
  doCheck = false;

  propagatedBuildInputs = [ msgpack ]
    ++ lib.optional (!isPyPy) greenlet;

  meta = {
    description = "Python client for Neovim";
    homepage = "https://github.com/neovim/python-client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
