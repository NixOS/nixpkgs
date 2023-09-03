{ lib, stdenv, fetchFromGitHub, boost, gtkmm2, lv2, pkg-config, python3, wafHook }:

stdenv.mkDerivation rec {
  pname = "lvtk";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "lvtk";
    repo = "lvtk";
    rev = version;
    sha256 = "sha256-6IoyhBig3Nvc4Y8F0w8b1up6sn8O2RmoUVaBQ//+Aaw=";
  };

  nativeBuildInputs = [ pkg-config python3 wafHook ];
  buildInputs = [ boost gtkmm2 lv2 ];

  enableParallelBuilding = true;

  postPatch = ''
    # Fix including the boost libraries during linking
    sed -i '/target[ ]*= "ttl2c"/ ilib=["boost_system"],' tools/wscript_build

    # don't use bundled waf
    rm waf

    # remove (useless) python2 based print
    sed -e '/print/d' -i wscript
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
