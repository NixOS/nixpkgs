{ lib, stdenv, fetchFromGitHub, cmake, libiio }:

stdenv.mkDerivation rec {
  pname = "libad9361";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "libad9361-iio";
    rev = "v${version}";
    hash = "sha256-dYoFWRnREvlOC514ZpmmvoS37DmIkVqfq7JPpTXqXd8=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libiio ];

  meta = with lib; {
    description = "IIO AD9361 library for filter design and handling, multi-chip sync, etc";
    homepage = "http://analogdevicesinc.github.io/libad9361-iio/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
  };
}
