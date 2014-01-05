{ stdenv, fetchurl, gtk, libsndfile, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "lv2-${version}";
  version = "1.6.0";

  src = fetchurl {
    url = "http://lv2plug.in/spec/${name}.tar.bz2";
    sha256 = "0nxrkmcpsm4v25wp2l7lcw4n0823kbplilpv51fszf710qsn7k9v";
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
