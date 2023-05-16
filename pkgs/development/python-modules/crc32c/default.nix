<<<<<<< HEAD
{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, pytestCheckHook }:

buildPythonPackage rec {
  version = "2.3.post0";
  pname = "crc32c";
  format = "setuptools";

  disabled = pythonOlder "3.5";
=======
{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  version = "2.2.post0";
  pname = "crc32c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ICRAR";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-lPEojWeAhfWpGR+k+Tuo4n68iZOk7lUDxjWXj5vN4I0=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

=======
    rev = "v${version}";
    hash = "sha256-0FgNOVpgJTxRALuufZ7Dt1TwuX+zqw35yCq8kmq4RTc=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = {
    description = "Python software implementation and hardware API of CRC32C checksum algorithm";
    homepage = "https://github.com/ICRAR/crc32c";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
