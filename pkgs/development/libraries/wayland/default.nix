{ lib, stdenv, fetchurl, pkgconfig
, libffi, docbook_xsl, doxygen, graphviz, libxslt, xmlto, libxml2
, expat ? null # Build wayland-scanner (currently cannot be disabled as of 1.7.0)
}:

# Require the optional to be enabled until upstream fixes or removes the configure flag
assert expat != null;

stdenv.mkDerivation rec {
  name = "wayland-${version}";
  version = "1.10.0";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "1p307ly1yyqjnzn9dbv78yffql2qszn84qk74lwanl3gma8fgxjb";
  };

  configureFlags = "--with-scanner --disable-documentation";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libffi /* docbook_xsl doxygen graphviz libxslt xmlto */ expat libxml2 ];

  meta = {
    description = "Reference implementation of the wayland protocol";
    homepage    = http://wayland.freedesktop.org/;
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ codyopel wkennington ];
  };

  passthru.version = version;
}
