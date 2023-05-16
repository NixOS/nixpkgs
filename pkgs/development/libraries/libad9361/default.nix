{ lib, stdenv, fetchFromGitHub, cmake, libiio }:

stdenv.mkDerivation rec {
  pname = "libad9361";
<<<<<<< HEAD
  version = "0.3";
=======
  version = "0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "libad9361-iio";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-9e66qSrKpczatZY9lPAzi/6f7lHChnl2+Pih53oa28Y=";
=======
    hash = "sha256-dYoFWRnREvlOC514ZpmmvoS37DmIkVqfq7JPpTXqXd8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libiio ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    # Fix iio include path on darwin to match linux
    for i in test/*.c; do
      substituteInPlace $i \
        --replace 'iio/iio.h' 'iio.h'
    done
  '';

  meta = with lib; {
    description = "IIO AD9361 library for filter design and handling, multi-chip sync, etc";
    homepage = "http://analogdevicesinc.github.io/libad9361-iio/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
