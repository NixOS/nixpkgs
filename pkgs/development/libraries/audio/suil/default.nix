{ stdenv, lib, fetchurl, gtk2, lv2, pkgconfig, python, serd, sord, sratom, gcc6
, withQt4 ? true, qt4 ? null
, withQt5 ? false, qt5 ? null }:

# I haven't found an XOR operator in nix...
assert withQt4 || withQt5;
assert !(withQt4 && withQt5);

stdenv.mkDerivation rec {
  pname = "suil";
  version = "0.8.4";
  name = "${pname}-qt${if withQt4 then "4" else "5"}-${version}";

  src = fetchurl {
    url = "http://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "1kji3lhha26qr6xm9j8ic5c40zbrrb5qnwm2qxzmsfxgmrz29wkf";
  };

  buildInputs = [ gtk2 lv2 pkgconfig python serd sord sratom gcc6 ]
    ++ (lib.optionals withQt4 [ qt4 ])
    ++ (lib.optionals withQt5 (with qt5; [ qtbase qttools ]));

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/suil;
    description = "A lightweight C library for loading and wrapping LV2 plugin UIs";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
