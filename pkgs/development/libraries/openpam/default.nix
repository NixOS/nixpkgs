{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "openpam-${version}";
  version = "20170430";

  src = fetchurl {
    url = "mirror://sourceforge/openpam/openpam/Resedacea/${name}.tar.gz";
    sha256 = "0pz8kf9mxj0k8yp8jgmhahddz58zv2b7gnyjwng75xgsx4i55xi2";
  };

  meta = {
    homepage = https://www.openpam.org;
    description = "An open source PAM library that focuses on simplicity, correctness, and cleanliness";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ matthewbauer ];
  };
}
