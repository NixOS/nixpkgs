{ lib, stdenv, fetchurl, lv2, pkg-config, python3, serd, sord, sratom, wafHook

# test derivations
, pipewire
}:

stdenv.mkDerivation rec {
  pname = "lilv";
  version = "0.24.14";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    hash = "sha256-Y5nfy+rWGhQ6zvOjitB4BHqyJbAEcK1dM3RWNzQdZAY=";
  };

  patches = [ ./lilv-pkgconfig.patch ];

  nativeBuildInputs = [ pkg-config python3 wafHook ];
  buildInputs = [ serd sord sratom ];
  propagatedBuildInputs = [ lv2 ];
  dontAddWafCrossFlags = true;

  passthru.tests = {
    inherit pipewire;
  };

  meta = with lib; {
    homepage = "http://drobilla.net/software/lilv";
    description = "A C library to make the use of LV2 plugins";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
