{ stdenv, fetchurl, boost, gtkmm, lv2, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "lvtk-${version}";
  version = "1.1.1";

  src = fetchurl {
    url = "http://lvtoolkit.org/code/browse/lvtk/snapshot/${name}.tar.gz";
    sha256 = "161l4n3a2kar2r5mn3zz6dbj1p2s6361ainrka3s74518z7yf42w";
  };

  buildInputs = [ boost gtkmm lv2 pkgconfig python ];

  configurePhase = ''
    python waf configure --prefix=$out --boost-includes=${boost}/include
  '';

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    description = "A set C++ wrappers around the LV2 C API";
    homepage = http://lvtoolkit.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
