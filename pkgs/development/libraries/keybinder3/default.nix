{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pkgconfig, gnome3
, gtk-doc, gtk3, libX11, libXext, libXrender, gobject-introspection
}:

stdenv.mkDerivation rec {
  name = "keybinder3-${version}";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "kupferlauncher";
    repo = "keybinder";
    rev = "keybinder-3.0-v${version}";
    sha256 = "196ibn86j54fywfwwgyh89i9wygm4vh7ls19fn20vrnm6ijlzh9r";
  };

  nativeBuildInputs = [ autoconf automake libtool pkgconfig ];
  buildInputs = [
    gnome3.gnome-common gtk-doc gtk3
    libX11 libXext libXrender gobject-introspection
  ];

  preConfigure = ''
    ./autogen.sh --prefix="$out"
  '';

  meta = with stdenv.lib; {
    description = "Library for registering global key bindings";
    homepage = https://github.com/kupferlauncher/keybinder/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.cstrahan ];
  };
}
