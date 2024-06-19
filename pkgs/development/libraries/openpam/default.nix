{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "openpam";
  version = "20170430";

  src = fetchurl {
    url = "mirror://sourceforge/openpam/openpam/Resedacea/${pname}-${version}.tar.gz";
    sha256 = "0pz8kf9mxj0k8yp8jgmhahddz58zv2b7gnyjwng75xgsx4i55xi2";
  };

  meta = with lib; {
    homepage = "https://www.openpam.org";
    description = "Open source PAM library that focuses on simplicity, correctness, and cleanliness";
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
    license = licenses.bsd3;
  };
}
