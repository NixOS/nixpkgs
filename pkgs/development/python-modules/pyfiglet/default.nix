{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
<<<<<<< HEAD
  version = "1.0.1";
=======
  version = "0.8.post1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "pyfiglet";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    sha256 = "sha256-x9kIim+CG99pxY2XVzeAhadogWJrIwjmu9pwcSFgfxg=";
=======
    sha256 = "c6c2321755d09267b438ec7b936825a4910fec696292139e664ca8670e103639";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  doCheck = false;

  meta = with lib; {
    description = "FIGlet in pure Python";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
