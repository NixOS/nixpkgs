{ stdenv, fetchurl, pkgconfig
, libffi, docbook_xsl, doxygen, graphviz, libxslt, xmlto
, expat ? null # Build wayland-scanner (currently cannot be disabled as of 1.7.0)
}:

# Require the optional to be enabled until upstream fixes or removes the configure flag
assert expat != null;

let
  mkFlag = optSet: flag: if optSet then "--enable-${flag}" else "--disable-${flag}";
in

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "wayland-${version}";
  version = "1.7.0";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "173w0pqzk2m7hjlg15bymrx7ynxgq1ciadg03hzybxwnvfi4gsmx";
  };

  configureFlags = [
    (mkFlag (expat != null) "scanner")
  ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libffi docbook_xsl doxygen graphviz libxslt xmlto expat ];

  meta = {
    description = "Reference implementation of the wayland protocol";
    homepage    = http://wayland.freedesktop.org/;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ codyopel wkennington ];
  };

  passthru.version = version;
}
