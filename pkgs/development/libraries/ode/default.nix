{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ode";
  version = "0.12";

  src = fetchurl {
    url = "mirror://sourceforge/opende/ode-${version}.tar.bz2";
    sha256 = "0l63ymlkgfp5cb0ggqwm386lxmc3al21nb7a07dd49f789d33ib5";
  };

  meta = with lib; {
    description = "Open Dynamics Engine";
    homepage = "https://sourceforge.net/projects/opende";
    platforms = platforms.linux;
    license = with licenses; [ bsd3 lgpl21 lgpl3 zlib ];
  };
}
