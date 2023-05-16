{ lib
<<<<<<< HEAD
, stdenv
, buildPythonPackage
=======
, buildPythonPackage
, coreutils
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, icontract
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD
, substituteAll
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pylddwrap";
  version = "1.2.2";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Parquery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Gm82VRu8GP52BohQzpMUJfh6q2tiUA2GJWOcG7ymGgg=";
  };

<<<<<<< HEAD
  patches = [
    (substituteAll {
      src = ./replace_env_with_placeholder.patch;
      ldd_bin = "${stdenv.cc.bintools.libc_bin}/bin/ldd";
    })
  ];
=======
  postPatch = ''
    substituteInPlace lddwrap/__init__.py \
      --replace '/usr/bin/env' '${coreutils}/bin/env'
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Upstream adds some plain text files direct to the package's root directory
  # https://github.com/Parquery/pylddwrap/blob/master/setup.py#L71
  postInstall = ''
    rm -f $out/{LICENSE,README.rst,requirements.txt}
  '';

  propagatedBuildInputs = [
    icontract
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  # uses mocked ldd from PATH, but we are patching the source to not look at PATH
  disabledTests = [
    "TestAgainstMockLdd"
    "TestMain"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [ "lddwrap" ];

  meta = with lib; {
    description = "Python wrapper around ldd *nix utility to determine shared libraries of a program";
    homepage = "https://github.com/Parquery/pylddwrap";
    changelog = "https://github.com/Parquery/pylddwrap/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ thiagokokada ];
<<<<<<< HEAD
    # should work in any Unix platform that uses glibc, except for darwin
    # since it has its own tool (`otool`)
    badPlatforms = platforms.darwin;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
