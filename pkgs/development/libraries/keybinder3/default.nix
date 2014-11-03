{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pkgconfig, gnome3, pygobject3, pygtk
, gtk_doc, gtk3, python, pygobject, lua, libX11, libXext, libXrender, gobjectIntrospection
}:

stdenv.mkDerivation rec {
  name = "keybinder3-${version}";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "engla";
    repo = "keybinder";
    rev = "keybinder-3.0-v${version}";
    sha256 = "1jdcrfhvqffhc2h69197wkpc5j5synk5mm8rqhz27qfrfhh4vf0q";
  };

  buildInputs = [
    autoconf automake libtool pkgconfig gnome3.gnome_common gtk_doc
    libX11 libXext libXrender gobjectIntrospection gtk3
  ];

  preConfigure = ''
    ./autogen.sh --prefix="$out"
  '';

  meta = with stdenv.lib; {
    description = "Library for registering global key bindings";
    homepage = https://github.com/engla/keybinder/;
    license = licenses.mit;
    platform = platforms.linux;
    maintainers = [ maintainers.cstrahan ];
  };
}
