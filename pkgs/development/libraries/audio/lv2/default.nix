{ stdenv, fetchurl, gtk, libsndfile, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "lv2-${version}";
  version = "1.4.0";

  src = fetchurl {
    url = "http://lv2plug.in/spec/${name}.tar.bz2";
    sha256 = "035hlfva2mij698nj3z1mz9g4mj4z5jx9axs6ww47jgyjcq38asz";
  };

  buildInputs = [ gtk libsndfile pkgconfig python ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    homepage = http://lv2plug.in;
    description = "A plugin standard for audio systems";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];

  };
}
