{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "pthread-stubs-0.1";
  src = fetchurl {
    url = http://xcb.freedesktop.org/dist/libpthread-stubs-0.1.tar.bz2;
    sha256 = "0raxl73kmviqinp00bfa025d0j4vmfjjcvfn754mi60mw48swk80";
  };
}
