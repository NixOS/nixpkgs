{ lib, stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "uchardet";
  version = "0.0.7";

  outputs = [ "bin" "out" "man" "dev" ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/releases/${pname}-${version}.tar.xz";
    sha256 = "1ca51sryhryqz82v4d0graaiqqq5w2f33a9gj83b910xmq499irz";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = !stdenv.isi686; # tests fail on i686

  meta = with lib; {
    description = "Mozilla's Universal Charset Detector C/C++ API";
    homepage = "https://www.freedesktop.org/wiki/Software/uchardet/";
    license = licenses.mpl11;
    maintainers = with maintainers; [ cstrahan ];
    platforms = with platforms; unix;
  };
}
