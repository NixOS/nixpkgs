{ stdenv, fetchurl
, glib
, gtk3
, libffcall
, pkgconfig
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gtk-server";
  version = "2.4.5";

  src = fetchurl {
    url = "https://www.gtk-server.org/stable/gtk-server-${version}.tar.gz";
    sha256 = "0vlx5ibvc7hyc8yipjgvrx1azvmh42i9fv1khg3dvn09nrdkrc7f";
  };

  preConfigure = ''
    cd src
  '';

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [ libffcall glib gtk3 ];

  configureOptions = [ "--with-gtk3" ];

  meta = with stdenv.lib; {
    description = "gtk-server for interpreted GUI programming";
    homepage = "http://www.gtk-server.org/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.tohl ];
    platforms = platforms.linux;
  };
}
