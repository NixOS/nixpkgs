{ stdenv
, lib
, fetchFromGitHub
, pkgconfig
, mono
, glib
, pango
, gtk2
, GConf ? null
, libglade ? null
, libgtkhtml ? null
, gtkhtml ? null
, libgnomecanvas ? null
, libgnomeui ? null
, libgnomeprint ? null
, libgnomeprintui ? null
, libxml2
, monoDLLFixer
, autoconf
, automake
, libtool
, which
}:

stdenv.mkDerivation rec {
  name = "gtk-sharp-${version}";
  version = "2.12.45";

  builder = ./builder.sh;
  src = fetchFromGitHub {
    owner = "mono";
    repo = "gtk-sharp";
    rev = version;
    sha256 = "1vy6yfwkfv6bb45bzf4g6dayiqkvqqvlr02rsnhd10793hlpqlgg";
  };

  postInstall = ''
    pushd $out/bin
    for f in gapi2-*
    do
      substituteInPlace $f --replace mono ${mono}/bin/mono
    done
    popd
  '';

  nativeBuildInputs = [ pkgconfig autoconf automake libtool which ];

  buildInputs = [
    mono glib pango gtk2 GConf libglade libgnomecanvas
    libgtkhtml libgnomeui libgnomeprint libgnomeprintui gtkhtml libxml2
  ];

  preConfigure = ''
    ./bootstrap-${lib.versions.majorMinor version}
  '';

  dontStrip = true;

  inherit monoDLLFixer;

  passthru = {
    gtk = gtk2;
  };

  meta = with stdenv.lib; {
    description = "Graphical User Interface Toolkit for mono and .Net";
    homepage = https://www.mono-project.com/docs/gui/gtksharp;
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
