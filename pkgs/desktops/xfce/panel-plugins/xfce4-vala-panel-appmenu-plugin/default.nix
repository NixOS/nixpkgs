{ stdenv, fetchFromGitHub, substituteAll, callPackage, pkgconfig, cmake, vala, libxml2,
  glib, pcre, gtk2, gtk3, xorg, libxkbcommon, epoxy, at-spi2-core, dbus-glib, bamf,
  xfce, libwnck3, libdbusmenu, gobject-introspection }:

stdenv.mkDerivation rec {
  name = "xfce4-vala-panel-appmenu-plugin-${version}";
  version = "0.6.94";

  src = fetchFromGitHub {
    owner = "rilian-la-te";
    repo = "vala-panel-appmenu";
    rev = version;
    fetchSubmodules = true;

    sha256 = "0xxn3zs60a9nfix8wrdp056wviq281cm1031hznzf1l38lp3wr5p";
  };

  nativeBuildInputs = [ pkgconfig cmake vala libxml2.bin ];
  buildInputs = [ (callPackage ./appmenu-gtk-module.nix {})
                  glib pcre gtk2 gtk3 xorg.libpthreadstubs xorg.libXdmcp libxkbcommon epoxy
                  at-spi2-core dbus-glib bamf xfce.xfce4panel_gtk3 xfce.libxfce4util xfce.xfconf
                  libwnck3 libdbusmenu gobject-introspection ];

  patches = [
    (substituteAll {
      src = ./fix-bamf-dependency.patch;
      bamf = bamf;
    })
  ];

  cmakeFlags = [
      "-DENABLE_XFCE=ON"
      "-DENABLE_BUDGIE=OFF"
      "-DENABLE_VALAPANEL=OFF"
      "-DENABLE_MATE=OFF"
      "-DENABLE_JAYATANA=OFF"
      "-DENABLE_APPMENU_GTK_MODULE=OFF"
  ];

  preConfigure = ''
    mv cmake/FallbackVersion.cmake.in cmake/FallbackVersion.cmake
  '';

  meta = with stdenv.lib; {
    description = "Global Menu applet for XFCE4";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jD91mZM2 ];
  };
}
