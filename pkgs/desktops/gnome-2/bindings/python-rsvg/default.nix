{ stdenv, fetchurl, gnome2, librsvg, pkgconfig, python27Packages, gtk }:

let
  inherit (python27Packages) python pygtk;
in stdenv.mkDerivation rec {
  ver_maj = "2.32";
  ver_min = "0";
  version = "${ver_maj}.${ver_min}";
  name = "python-rsvg-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-python-desktop/${ver_maj}/gnome-python-desktop-${version}.tar.bz2";
    sha256 = "1s8f9rns9v7qlwjv9qh9lr8crp88dpzfm45hj47zc3ivpy0dbnq9";
  };

  configurePhase = ''
    sed -e "s@{PYTHONDIR}/gtk-2.0@{PYTHONDIR}/@" -i rsvg/wscript
    python waf configure --enable-modules=rsvg --prefix=$out
  '';

  buildPhase = "python waf build";

  installPhase = "python waf install";

  buildInputs = [ gtk gnome2.gnome_python librsvg pkgconfig pygtk python ];

  meta = with stdenv.lib; {
    homepage = "http://www.pygtk.org";
    description = "The rsvg python module";
    license = licenses.lgpl21;
    maintainers = [ maintainers.goibhniu ];
  };
}
