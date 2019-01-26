{ stdenv, fetchurl, boost, gtkmm2, lv2, pkgconfig, python, wafHook }:

stdenv.mkDerivation rec {
  name = "lvtk-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/lvtk/lvtk/archive/${version}.tar.gz";
    sha256 = "03nbj2cqcklqwh50zj2gwm07crh5iwqbpxbpzwbg5hvgl4k4rnjd";
  };

  nativeBuildInputs = [ pkgconfig python wafHook ];
  buildInputs = [ boost gtkmm2 lv2 ];

  enableParallelBuilding = true;

  # Fix including the boost libraries during linking
  postPatch = ''
    sed -i '/target[ ]*= "ttl2c"/ ilib=["boost_system"],' tools/wscript_build
  '';

  configureFlags = [
    "--boost-includes=${boost.dev}/include"
    "--boost-libs=${boost.out}/lib"
  ];

  meta = with stdenv.lib; {
    description = "A set C++ wrappers around the LV2 C API";
    homepage = http://lvtoolkit.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
