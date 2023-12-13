{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ode";
  version = "0.16.4";

  src = fetchurl {
    url = "https://bitbucket.org/odedevs/${pname}/downloads/${pname}-${version}.tar.gz";
    sha256 = "sha256-cQN7goHGyGsKVXKfkNXbaXq+TL7B2BGBV+ANSOwlNGc=";
  };

  meta = with lib; {
    description = "Open Dynamics Engine";
    homepage = "https://www.ode.org";
    platforms = platforms.linux;
    license = with licenses; [ bsd3 lgpl21 lgpl3 zlib ];
  };
}
