{ stdenv, fetchurl, gnome, librsvg, pkgconfig, pygtk, python }:

stdenv.mkDerivation rec {
  version = "2.32";
  name = "python-rsvg-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-python-desktop/${version}/gnome-python-desktop-${version}.0.tar.gz";
    sha256 = "1xhh3h1qdnimydvv55pmqwyzjchhjwfvp951sjlq0180kskqrlj5";
  };

  configurePhase = ''
    sed -e "s@{PYTHONDIR}/gtk-2.0@{PYTHONDIR}/@" -i rsvg/wscript 
    python waf configure --enable-modules=rsvg --prefix=$out 
  '';

  buildPhase = "python waf build";

  installPhase = "python waf install";

  buildInputs = [ gnome.gnome_python librsvg pkgconfig pygtk python ];

  meta = with stdenv.lib; {
    homepage = "http://www.pygtk.org";
    description = "The rsvg python module";
    license = licenses.lgpl21;
    maintainers = [ maintainers.goibhniu ];
  };
}
