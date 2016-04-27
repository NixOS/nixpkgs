{ stdenv, fetchurl, boost, gtkmm, lv2, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "lvtk-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/lvtk/lvtk/archive/${version}.tar.gz";
    sha256 = "03nbj2cqcklqwh50zj2gwm07crh5iwqbpxbpzwbg5hvgl4k4rnjd";
  };

  nativeBuildInputs = [ pkgconfig python ];
  buildInputs = [ boost gtkmm lv2 ];

  # Fix including the boost libraries during linking
  postPatch = ''
    sed -i '/target[ ]*= "ttl2c"/ ilib=["boost_system"],' tools/wscript_build
  '';

  configurePhase = ''
    python waf configure --prefix=$out \
      --boost-includes="${boost.dev}/include" \
      --boost-libs="${boost.out}/lib"
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
