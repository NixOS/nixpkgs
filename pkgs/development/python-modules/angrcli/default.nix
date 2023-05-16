{ stdenv
, lib
, angr
, buildPythonPackage
, cmd2
, coreutils
, fetchFromGitHub
, pygments
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "angrcli";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "fmagin";
    repo = "angr-cli";
    rev = "v${version}";
    hash = "sha256-a5ajUBQwt3xUNkeSOeGOAFf47wd4UVk+LcuAHGqbq4s=";
  };

<<<<<<< HEAD
  postPatch = ''
    substituteInPlace tests/test_derefs.py \
      --replace "/bin/ls" "${coreutils}/bin/ls"
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    angr
    cmd2
    pygments
  ];

  nativeCheckInputs = [
    coreutils
    pytestCheckHook
  ];

<<<<<<< HEAD
  disabledTests = lib.optionals (!stdenv.hostPlatform.isx86) [
    # expects the x86 register "rax" to exist
    "test_cc"
    "test_loop"
    "test_max_depth"
=======
  postPatch = ''
    substituteInPlace tests/test_derefs.py \
      --replace "/bin/ls" "${coreutils}/bin/ls"
  '';

  disabledTests = [
    "test_sims"
    "test_proper_termination"
    "test_branching"
    "test_morph"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "angrcli"
  ];

  meta = with lib; {
<<<<<<< HEAD
=======
    broken = (stdenv.isLinux && stdenv.isAarch64);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Python modules to allow easier interactive use of angr";
    homepage = "https://github.com/fmagin/angr-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
