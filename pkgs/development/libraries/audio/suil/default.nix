{ stdenv, lib, fetchurl, gtk2, lv2, pkgconfig, python, serd, sord, sratom
, wafHook
, withQt4 ? true, qt4 ? null
, withQt5 ? false, qt5 ? null }:

# I haven't found an XOR operator in nix...
assert withQt4 || withQt5;
assert !(withQt4 && withQt5);

stdenv.mkDerivation rec {
  pname = "suil";
  version = "0.10.6";
  name = "${pname}-qt${if withQt4 then "4" else "5"}-${version}";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "0z4v01pjw4wh65x38w6icn28wdwxz13ayl8hvn4p1g9kmamp1z06";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ gtk2 lv2 python serd sord sratom ]
    ++ (lib.optionals withQt4 [ qt4 ])
    ++ (lib.optionals withQt5 (with qt5; [ qtbase qttools ]));

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/suil;
    description = "A lightweight C library for loading and wrapping LV2 plugin UIs";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
