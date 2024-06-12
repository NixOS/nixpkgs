{ stdenv, lib, fetchurl, gtk2, lv2, pkg-config, python3, serd, sord, sratom
, wafHook
, withQt5 ? true, qt5 ? null
}:

stdenv.mkDerivation rec {
  pname = "suil";
  version = "0.10.6";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "0z4v01pjw4wh65x38w6icn28wdwxz13ayl8hvn4p1g9kmamp1z06";
  };

  nativeBuildInputs = [ pkg-config wafHook python3 ];
  buildInputs = [ gtk2 lv2 serd sord sratom ]
    ++ lib.optionals withQt5 (with qt5; [ qtbase qttools ]);

  dontWrapQtApps = true;

  strictDeps = true;

  meta = with lib; {
    homepage = "http://drobilla.net/software/suil";
    description = "Lightweight C library for loading and wrapping LV2 plugin UIs";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.unix;
  };
}
