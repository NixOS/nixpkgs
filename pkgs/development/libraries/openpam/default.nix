{ lib, stdenv, fetchurl, pkg-config }:

stdenv.mkDerivation rec {
  pname = "openpam";
  version = "20230627";

  src = fetchurl {
    url = "mirror://sourceforge/openpam/openpam/Ximenia/openpam-${version}.tar.gz";
    hash = "sha256-DZrI9bVaYkH1Bz8T7/HpVGFCLEWsGjBEXX4QaOkdtP0=";
  };

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    homepage = "https://www.openpam.org";
    description = "An open source PAM library that focuses on simplicity, correctness, and cleanliness";
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
    license = licenses.bsd3;
  };
}
