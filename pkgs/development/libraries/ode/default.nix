{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ode";
  version = "0.16.2";

  src = fetchurl {
    url = "https://bitbucket.org/odedevs/${pname}/downloads/${pname}-${version}.tar.gz";
    sha256 = "08hgh4gqdk77jcw8b7gq2mwsfg4a5v5y0j7g42bxiqhmn3ffnsmj";
  };

  meta = with lib; {
    description = "Open Dynamics Engine";
    homepage = "https://www.ode.org";
    platforms = platforms.linux;
    license = with licenses; [ bsd3 lgpl21 lgpl3 zlib ];
  };
}
