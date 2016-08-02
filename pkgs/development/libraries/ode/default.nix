{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ode-${version}";
  version = "0.12";

  src = fetchurl {
    url = "mirror://sourceforge/opende/ode-${version}.tar.bz2";
    sha256 = "0l63ymlkgfp5cb0ggqwm386lxmc3al21nb7a07dd49f789d33ib5";
  };

  meta = {
    description = "Open Dynamics Engine";
    platforms = stdenv.lib.platforms.linux;
  };
}
