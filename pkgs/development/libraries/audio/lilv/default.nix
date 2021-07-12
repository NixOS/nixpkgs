{ lib, stdenv, fetchurl, lv2, pkg-config, python3, serd, sord, sratom, wafHook }:

stdenv.mkDerivation rec {
  pname = "lilv";
  version = "0.24.12";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "sha256-JqN3kIkMnB+DggO0f1sjIDNP6SwCpNJuu+Jmnb12kGE=";
  };

  patches = [ ./lilv-pkgconfig.patch ];

  nativeBuildInputs = [ pkg-config python3 wafHook ];
  buildInputs = [ serd sord sratom ];
  propagatedBuildInputs = [ lv2 ];

  meta = with lib; {
    homepage = "http://drobilla.net/software/lilv";
    description = "A C library to make the use of LV2 plugins";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
