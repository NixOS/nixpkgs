{ stdenv, fetchFromGitHub, autoreconfHook
, pkgconfig, glib, systemd, libgudev, vala  }:

stdenv.mkDerivation rec {
  name = "umockdev";
  version = "0.8.13";

  src = fetchFromGitHub {
    owner = "martinpitt";
    repo = "umockdev";
    rev = version;
    sha256 ="0bw2dpshlgbdwg5mhq4j22z474llpqix8pxii63r2bk5nhjc537k";
  };

  buildInputs = [ glib systemd libgudev vala ];
  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  ### docs/gtk-doc.make not found
  prePatch = ''
    sed -i 's|include $(top_srcdir)/docs/gtk-doc.make||g' docs/reference/Makefile.am
   sed -i 's|+=|=|g' docs/reference/Makefile.am
   '';

  meta = with stdenv.lib; {
    description = "Mock hardware devices for creating unit tests";
    license = licenses.lgpl2;
    maintainers = [ maintainers.ndowens ];
  };
}
