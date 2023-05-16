{ qtModule
<<<<<<< HEAD
, fetchFromGitHub
=======
, fetchurl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, qtbase
}:

qtModule rec {
  pname = "qtmqtt";
<<<<<<< HEAD
  version = "6.5.2";
  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    rev = "v${version}";
    hash = "sha256-yyerVzz+nGT5kjNo24zYqZcJmrE50KCp38s3+samjd0=";
=======
  version = "6.5.0";
  src = fetchurl {
    url = "https://github.com/qt/qtmqtt/archive/refs/tags/v${version}.tar.gz";
    sha256 = "qv3GYApd4QKk/Oubx48VhG/Dbl/rvq5ua0UinPlDDNY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  qtInputs = [ qtbase ];
}
