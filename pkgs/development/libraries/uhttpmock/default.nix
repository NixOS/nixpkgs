{ stdenv, lib, fetchFromGitLab, autoconf, gtk-doc, automake, libtool, pkg-config, glib, libsoup, gobject-introspection }:

stdenv.mkDerivation rec {
  version="0.5.0";
  pname = "uhttpmock";

  src = fetchFromGitLab {
    repo = "uhttpmock";
    owner = "uhttpmock";
    rev = version;
    sha256 = "0kkf670abkq5ikm3mqls475lydfsd9by1kv5im4k757xrl1br1d4";
  };

  nativeBuildInputs = [ pkg-config autoconf automake gtk-doc libtool gobject-introspection ];
  buildInputs = [ glib libsoup ];

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  # while cross
  # /build/source/tmp-introspect3xf43lf3/.libs/Uhm-0.0: error while loading shared libraries: libuhttpmock-0.0.so.0: cannot open shared object file: No such file or directory
  preBuild = ''
    mkdir -p ${placeholder "out"}/lib
    ln -s $PWD/libuhttpmock/.libs/libuhttpmock-0.0.so.0 ${placeholder "out"}/lib/libuhttpmock-0.0.so.0
  '';

  meta = with lib; {
    description = "Project for mocking web service APIs which use HTTP or HTTPS";
    homepage = "https://gitlab.com/groups/uhttpmock/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ];
    platforms = with platforms; linux;
  };
}
