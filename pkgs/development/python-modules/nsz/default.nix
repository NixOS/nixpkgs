<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitHub
, pycryptodome
, pythonOlder
, enlighten
, zstandard
=======
{ lib, buildPythonPackage, fetchFromGitHub, pycryptodome, enlighten, zstandard
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, withGUI ? true
, kivy
}:

buildPythonPackage rec {
  pname = "nsz";
<<<<<<< HEAD
  version = "4.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "4.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nicoboss";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-glK4CK7D33FfLqHLxVr4kkb887/A9tqxPwWpcXYZu/0=";
  };

  propagatedBuildInputs = [
    pycryptodome
    enlighten
    zstandard
  ] ++ lib.optional withGUI kivy;
=======
    hash = "sha256-It815Uxxs4T9BM9EypAfPuq4Oy8rgGLpKA79m2xM8N4=";
  };

  propagatedBuildInputs = [pycryptodome enlighten zstandard ]
    ++ lib.optional withGUI kivy;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # do not check, as nsz requires producation keys
  # dumped from a Nintendo Switch.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/nicoboss/nsz";
<<<<<<< HEAD
    description = "Homebrew compatible NSP/XCI compressor/decompressor";
    changelog = "https://github.com/nicoboss/nsz/releases/tag/${version}";
=======
    description = "NSZ - Homebrew compatible NSP/XCI compressor/decompressor";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
