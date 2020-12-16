{ stdenv, fetchFromGitHub, cmake, libusb1, openblas, zlib }:

stdenv.mkDerivation rec {
  pname = "libsurvive";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "cntools";
    repo = "libsurvive";
    rev = "v${version}";
    sha256 = "0m21fnq8pfw2pcvqfgjws531zmalda423q9i65v4qzm8sdb54hl4";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libusb1 openblas zlib ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/cntools/libsurvive";
    description = "An open source Lighthouse Tracking System";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ expipiplus1 ];
  };
}

