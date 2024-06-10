{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config, gnome
, gtk-doc, gtk3, libX11, libXext, libXrender, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "keybinder3";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "kupferlauncher";
    repo = "keybinder";
    rev = "keybinder-3.0-v${version}";
    sha256 = "196ibn86j54fywfwwgyh89i9wygm4vh7ls19fn20vrnm6ijlzh9r";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    gnome.gnome-common
    gtk-doc
    gobject-introspection
  ];
  buildInputs = [
    gtk3 libX11 libXext libXrender
  ];

  preConfigure = ''
    # NOCONFIGURE fixes 'If you meant to cross compile, use `--host'.'
    NOCONFIGURE=1 ./autogen.sh --prefix="$out"
    substituteInPlace ./configure \
      --replace "dummy pkg-config" 'dummy ''${ac_tool_prefix}pkg-config'
  '';

  meta = with lib; {
    description = "Library for registering global key bindings";
    homepage = "https://github.com/kupferlauncher/keybinder/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
