{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, cmake
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "qxlsx";
<<<<<<< HEAD
  version = "1.4.6";
=======
  version = "1.4.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "QtExcel";
    repo = "QXlsx";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-8plnvyb4sQRfEac1TVWgr2yrtAVAPKucgAnsybdUd3U=";
  };

  patches = [
    # Fix header include path
    # https://github.com/QtExcel/QXlsx/pull/279
    (fetchpatch {
      url = "https://github.com/QtExcel/QXlsx/commit/9d6db9efb92b93c3663ccfef3aec05267ba43723.patch";
      hash = "sha256-EbE5CNACAcgENCQh81lBZJ52hCIcBsFhNnYOS0Wr25I=";
    })
  ];

=======
    hash = "sha256-T+PUeml4O6uwY6DCAsBer4gDo+nrSGGus+yQv02CJcE=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase ];

  preConfigure = ''
    cd QXlsx
  '';

  dontWrapQtApps = true;

  meta = with lib;{
    description = "Excel file(*.xlsx) reader/writer library using Qt 5 or 6";
    homepage = "https://qtexcel.github.io/QXlsx";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
  };
}
