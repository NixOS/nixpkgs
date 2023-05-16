{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config, gnome
, gtk-doc, gtk2, lua, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "keybinder";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "engla";
    repo = "keybinder";
    rev = "v${version}";
    sha256 = "sha256-elL6DZtzCwAtoyGZYP0jAma6tHPks2KAtrziWtBENGU=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ pkg-config autoconf automake gobject-introspection ];

  buildInputs = [
    libtool gnome.gnome-common gtk-doc gtk2
    lua
=======
  nativeBuildInputs = [ pkg-config autoconf automake ];

  buildInputs = [
    libtool gnome.gnome-common gtk-doc gtk2
    lua gobject-introspection
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  configureFlags = [ "--disable-python" ];

  preConfigure = ''
    ./autogen.sh --prefix="$out" $configureFlags
  '';

  meta = with lib; {
    description = "Library for registering global key bindings";
    longDescription = ''
      keybinder is a library for registering global keyboard shortcuts.
      Keybinder works with GTK-based applications using the X Window System.

      The library contains:

      * A C library, ``libkeybinder``
      * Gobject-Introspection (gir)  generated bindings
      * Lua bindings, ``lua-keybinder``
    '';
    homepage = "https://github.com/engla/keybinder/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
