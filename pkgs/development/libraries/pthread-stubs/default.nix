{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "pthread-stubs-${version}";
  version = "0.4";

  src = fetchurl {
    url = "https://xcb.freedesktop.org/dist/libpthread-stubs-${version}.tar.gz";
    sha256 = "1ng9f30hqhn6fmp6n56lrymk81m4wlpv1mybifhcx701g5mnimah";
  };

  meta = with stdenv.lib; {
    description = "pthread stubs not provided by native libc";
    homepage = "https://xcb.freedesktop.org";
    license = licenses.mit;
  };
}
