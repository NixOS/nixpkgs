{ lib, buildPythonPackage, fetchPypi, sphinx }:

buildPythonPackage rec {
  pname = "piccolo-theme";
<<<<<<< HEAD
  version = "0.17.0";
=======
  version = "0.14.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    pname = "piccolo_theme";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-sq/xWPLLAz4w6JdUfnB5E52hmj8gmrbg1oeBedyjCEE=";
=======
    hash = "sha256-PGPf05TQfC6Somn2PR07Y2qiOuyg+37U1l16m2LKykU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    sphinx
  ];

  pythonImportsCheck = [ "piccolo_theme" ];

  meta = with lib; {
    description = "Clean and modern Sphinx theme";
    homepage = "https://piccolo-theme.readthedocs.io";
<<<<<<< HEAD
    license = with licenses; [ mit asl20 ];
=======
    license = licenses.mit;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ loicreynier ];
    platforms = platforms.unix;
  };
}
