{ stdenv, fetchbzr
, gnome2, autoreconfHook, pkg-config
, glib
}:

stdenv.mkDerivation rec {
  pname = "geonames-unstable";
  version = "2019-02-14";

  # https://github.com/ubports/geonames is LFS-enabled, can't fetch
  src = fetchbzr {
    url = "lp:geonames";
    rev = "29";
    sha256 = "05jn4bbqma5q2zkxpdgk6jmvdxmjd5p6n58c5gmm244gd3aasznc";
  };

  postPatch = ''
    mkdir m4
    gtkdocize --copy
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ gnome2.gtk-doc autoreconfHook pkg-config ];

  buildInputs = [ glib ];

  meta = with stdenv.lib; {
    description = "Parse and query the geonames database dump";
    homepage = "https://github.com/ubports/geonames";
    license = with licenses; [ gpl3Only cc-by-30 ];
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
