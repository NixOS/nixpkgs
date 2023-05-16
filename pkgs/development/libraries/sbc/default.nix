{ lib, stdenv, fetchurl, pkg-config, libsndfile }:

stdenv.mkDerivation rec {
  pname = "sbc";
<<<<<<< HEAD
  version = "2.0";

  src = fetchurl {
    url = "https://www.kernel.org/pub/linux/bluetooth/${pname}-${version}.tar.xz";
    sha256 = "sha256-jxI2jh279V4UU2UgRzz7M4yEs5KTnMm2Qpg2D9SgeZI=";
  };

  outputs = [ "out" "dev" ];

=======
  version = "1.4";

  src = fetchurl {
    url = "https://www.kernel.org/pub/linux/bluetooth/${pname}-${version}.tar.xz";
    sha256 = "1jal98pnrjkzxlkiqy0ykh4qmgnydz9bmsp1jn581p5kddpg92si";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsndfile ];

  meta = with lib; {
    description = "SubBand Codec Library";
    homepage = "http://www.bluez.org/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
