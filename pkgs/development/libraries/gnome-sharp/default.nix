{ stdenv
, lib
, fetchFromGitHub
, pkgconfig
, gtk2
, mono
, gtk-sharp-2_0
, gnome2
, autoconf
, automake
, libtool
, which
}:

stdenv.mkDerivation rec {
  name = "gnome-sharp-${version}";
  version = "2.24.4";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "gnome-sharp";
    rev = "${version}";
    sha256 = "15jsm6n0sih0nf3w8vmvik97q7l3imz4vkdzmp9k7bssiz4glj1z";
  };

  nativeBuildInputs = [ pkgconfig autoconf automake libtool which ];
  buildInputs = [ gtk2 mono gtk-sharp-2_0 ]
  ++ (with gnome2; [ libart_lgpl gnome_vfs libgnome libgnomecanvas libgnomeui ]);

  preConfigure = ''
    ./bootstrap-${lib.versions.majorMinor version}
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    homepage = https://www.mono-project.com/docs/gui/gtksharp/;
    description = "A .NET language binding for assorted GNOME libraries";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ vbgl ];
  };
}
