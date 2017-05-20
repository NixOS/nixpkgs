{stdenv, pkgconfig, fetchurl}:

stdenv.mkDerivation rec {
  name = "libspiro-${version}";
  version = "0.5.20150702";
  src = fetchurl {
    url = "https://github.com/fontforge/libspiro/releases/download/${version}/${name}.tar.gz";
    sha256 = "0z4zpxd3nwwchqdsbmmjbp13aw5jg8v5p1993190bpykkrjlh6nv";
  };

  nativeBuildInputs = [pkgconfig];

  meta = with stdenv.lib; {
    description = "A library that simplifies the drawing of beautiful curves";
    homepage = "https://github.com/fontforge/libspiro";
    license = licenses.gpl3Plus;
  };
}
