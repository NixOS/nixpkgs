{ lib
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "pamela";
<<<<<<< HEAD
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1LE5/mAOGS4Xaio2gFkgemv/oOeHmHmxP0/LoBY0gb4=";
=======
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "65c9389bef7d1bb0b168813b6be21964df32016923aac7515bdf05366acbab6c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postUnpack = ''
    substituteInPlace $sourceRoot/pamela.py --replace \
      'find_library("pam")' \
      '"${lib.getLib pkgs.pam}/lib/libpam.so"'
  '';

  doCheck = false;

  meta = with lib; {
    description = "PAM interface using ctypes";
    homepage = "https://github.com/minrk/pamela";
    license = licenses.mit;
  };

}
