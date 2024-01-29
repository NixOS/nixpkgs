{ lib, stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "uchardet";
  version = "0.0.8";

  outputs = [ "bin" "out" "man" "dev" ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-6Xpgz8AKHBR6Z0sJe7FCKr2fp4otnOPz/cwueKNKxfA=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = !stdenv.isi686; # tests fail on i686

  meta = with lib; {
    description = "Mozilla's Universal Charset Detector C/C++ API";
    homepage = "https://www.freedesktop.org/wiki/Software/uchardet/";
    license = licenses.mpl11;
    maintainers = with maintainers; [ ];
    platforms = with platforms; unix;
  };
}
