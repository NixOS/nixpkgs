{ stdenv, fetchurl, gtk2, libsndfile, pkgconfig, python, wafHook }:

stdenv.mkDerivation rec {
  name = "lv2-${version}";
  version = "1.16.0";

  src = fetchurl {
    url = "http://lv2plug.in/spec/${name}.tar.bz2";
    sha256 = "1ppippbpdpv13ibs06b0bixnazwfhiw0d0ja6hx42jnkgdyp5hyy";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ gtk2 libsndfile python ];

  meta = with stdenv.lib; {
    homepage = http://lv2plug.in;
    description = "A plugin standard for audio systems";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
