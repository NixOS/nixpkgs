{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ode";
  version = "0.16.3";

  src = fetchurl {
    url = "https://bitbucket.org/odedevs/${pname}/downloads/${pname}-${version}.tar.gz";
    sha256 = "sha256-x0Hb9Jv8Rozilkgk5bw/kG6pVrGuNZTFDTUcOD8DxBM=";
  };

  meta = with lib; {
    description = "Open Dynamics Engine";
    homepage = "https://www.ode.org";
    platforms = platforms.linux;
    license = with licenses; [ bsd3 lgpl21 lgpl3 zlib ];
  };
}
