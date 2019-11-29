{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, glib, gettext, cinnamon-desktop, intltool, libxslt, gtk3, libnotify,
libxkbfile, cinnamon-menus, dbus-glib, libgnomekbd, libxklavier, networkmanager, libwacom, gnome3, libtool, wrapGAppsHook, tzdata, glibc, gobject-introspection, python3, pam }:

stdenv.mkDerivation rec {
  pname = "cinnamon-screensaver";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "03v41wk1gmgmyl31j7a3pav52gfv2faibj1jnpj3ycwcv4cch5w5";
  };

 buildInputs = [ glib (python3.withPackages (pp: with pp; [ pygobject3 setproctitle xapp ])) gtk3 pam ];

 NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0"; # TODO: https://github.com/NixOS/nixpkgs/issues/36468

  postPatch = ''
    patchShebangs autogen.sh
    sed "s|/usr/share/locale|/run/current-system/sw/share/locale|g" -i ./src/cinnamon-screensaver-main.py
    '';

  autoreconfPhase = ''
    NOCONFIGURE=1 bash ./autogen.sh
    '';

  nativeBuildInputs = [ pkgconfig autoreconfHook wrapGAppsHook gettext intltool libxslt libtool gobject-introspection ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/cinnamon-screensaver";
    description = "The Cinnamon screen locker and screensaver program ";

    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
