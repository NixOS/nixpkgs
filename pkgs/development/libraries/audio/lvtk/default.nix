{ lib, stdenv, fetchurl, boost, gtkmm2, lv2, pkg-config, python2, wafHook }:

stdenv.mkDerivation rec {
  pname = "lvtk";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/lvtk/lvtk/archive/${version}.tar.gz";
    sha256 = "03nbj2cqcklqwh50zj2gwm07crh5iwqbpxbpzwbg5hvgl4k4rnjd";
  };

  nativeBuildInputs = [ pkg-config python2 wafHook ];
  buildInputs = [ boost gtkmm2 lv2 ];

  enableParallelBuilding = true;

  # Fix including the boost libraries during linking
  postPatch = ''
    sed -i '/target[ ]*= "ttl2c"/ ilib=["boost_system"],' tools/wscript_build
  '';

  wafConfigureFlags = [
    "--boost-includes=${boost.dev}/include"
    "--boost-libs=${boost.out}/lib"
  ];

  meta = with lib; {
    description = "A set C++ wrappers around the LV2 C API";
    homepage = "https://lvtk.org/";
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
