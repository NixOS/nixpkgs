{ lib
, stdenv
, fetchurl
, glib
, gtk3
, libffcall
, pkg-config
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

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];
  buildInputs = [ libffcall glib gtk3 ];

  configureOptions = [ "--with-gtk3" ];

  meta = with lib; {
    homepage = "http://www.gtk-server.org/";
    description = "gtk-server for interpreted GUI programming";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
