{ stdenv, fetchurl, boost, gtkmm, lv2, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "lvtk-${version}";
  version = "1.1.1";

  src = fetchurl {
    url = "http://lvtoolkit.org/code/browse/lvtk/snapshot/${name}.tar.gz";
    sha256 = "1dr3rq4ycds455m4qbfajvgg12gmvv11whk80wdsi40dr6i3g86w";
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
