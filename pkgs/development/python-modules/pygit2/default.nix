{ lib
, stdenv
, buildPythonPackage
, cacert
, cached-property
, cffi
, fetchPypi
, isPyPy
<<<<<<< HEAD
, libgit2_1_6
=======
, libgit2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pycparser
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pygit2";
<<<<<<< HEAD
  version = "1.12.2";
=======
  version = "1.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-VuhdDmbelX1ZnR77JAnTmv7v2PAQCb/aB5a0Kktng1g=";
  };

  preConfigure = lib.optionalString stdenv.isDarwin ''
    export DYLD_LIBRARY_PATH="${libgit2_1_6}/lib"
  '';

  buildInputs = [
    libgit2_1_6
=======
    hash = "sha256-6UQNCGZeNSeJiZOVkKU/N6k46tpPlEaESTCqLuMNc74=";
  };

  preConfigure = lib.optionalString stdenv.isDarwin ''
    export DYLD_LIBRARY_PATH="${libgit2}/lib"
  '';

  buildInputs = [
    libgit2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    cached-property
    pycparser
  ] ++ lib.optionals (!isPyPy) [
    cffi
  ];

  propagatedNativeBuildInputs = lib.optionals (!isPyPy) [
    cffi
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Disable tests that require networking
    "test/test_repository.py"
    "test/test_credentials.py"
    "test/test_submodule.py"
  ];

  # Tests require certificates
  # https://github.com/NixOS/nixpkgs/pull/72544#issuecomment-582674047
  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

<<<<<<< HEAD
=======
  # setup.py check is broken
  # https://github.com/libgit2/pygit2/issues/868
  dontUseSetuptoolsCheck = true;

  # TODO: Test collection is failing
  # https://github.com/NixOS/nixpkgs/pull/72544#issuecomment-582681068
  doCheck = false;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "pygit2"
  ];

  meta = with lib; {
    description = "A set of Python bindings to the libgit2 shared library";
    homepage = "https://github.com/libgit2/pygit2";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
  };
}
