{ stdenv, lib, fetchFromGitLab, autoconf, gtk-doc, automake, libtool, pkgconfig, glib, libsoup, gobject-introspection }:

stdenv.mkDerivation rec {
  version="0.5.0";
  name = "uhttpmock-${version}";

  src = fetchFromGitLab {
    repo = "uhttpmock";
    owner = "uhttpmock";
    rev = version;
    sha256 = "0kkf670abkq5ikm3mqls475lydfsd9by1kv5im4k757xrl1br1d4";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf gtk-doc automake libtool glib libsoup gobject-introspection ];

  preConfigure = "./autogen.sh";

  meta = with lib; {
    description = "Project for mocking web service APIs which use HTTP or HTTPS";
    homepage = https://gitlab.com/groups/uhttpmock/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ];
    platforms = with platforms; linux;
  };
}
