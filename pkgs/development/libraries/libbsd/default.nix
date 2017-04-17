{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libbsd-${version}";
  version = "0.8.3";

  src = fetchurl {
    url = "http://libbsd.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "1a1l7afchlvvj2zfi7ajcg26bbkh5i98y2v5h9j5p1px9m7n6jwk";
  };

  meta = with stdenv.lib; {
    description = "Common functions found on BSD systems";
    homepage = http://libbsd.freedesktop.org/;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
