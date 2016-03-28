{ stdenv, fetchFromGitHub, autoconf, automake, which, pkgconfig, mono, gtk-sharp }:

stdenv.mkDerivation rec {
  name = "gio-sharp-${version}";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "gio-sharp";

    rev = "${version}";
    sha256 = "13pc529pjabj7lq23dbndc26ssmg5wkhc7lfvwapm87j711m0zig";
  };

  nativeBuildInputs = [ pkgconfig autoconf automake which ];
  buildInputs = [ mono gtk-sharp ];

  dontStrip = true;

  prePatch = ''
    ./autogen-2.22.sh
  '';

  meta = with stdenv.lib; {
    description = "GIO API bindings";
    platforms = platforms.linux;
  };
}
