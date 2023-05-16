{ lib, buildPythonPackage, fetchPypi, pefile, pillow}:

buildPythonPackage rec {
  pname = "icoextract";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-x0GEV0PUbkAzoUJgAqup9bHd7iYttGyzIZNdo8KsFyo=";
  };

  propagatedBuildInputs = [
    pefile
    pillow
  ];

  # tests expect mingw and multiarch
  doCheck = false;

  pythonImportsCheck = [
    "icoextract"
  ];

<<<<<<< HEAD
  postInstall = ''
    mkdir -p $out/share/thumbnailers
    substituteAll ${./exe-thumbnailer.thumbnailer} $out/share/thumbnailers/exe-thumbnailer.thumbnailer
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Extract icons from Windows PE files";
    homepage = "https://github.com/jlu5/icoextract";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ bryanasdev000 donovanglover ];
=======
    maintainers = with maintainers; [ bryanasdev000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
