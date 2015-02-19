{ stdenv, fetchurl, pkgconfig
, libffi
, scannerSupport ? true, expat ? null # Build wayland-scanner (currently cannot be disabled as of 1.7.0)
, documentationSupport ? false, docbook_xsl ? null, doxygen ? null, graphviz-nox ? null, libxslt ? null, xmlto ? null #, publican ? null
}:

# Require the optional to be enabled until upstream fixes or removes the configure flag
assert scannerSupport;

assert scannerSupport -> (expat != null);
assert documentationSupport -> ((docbook_xsl != null) && (doxygen != null) && (graphviz-nox != null) && (libxslt != null) && (xmlto != null));

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
    (mkFlag scannerSupport "scanner")
    (mkFlag documentationSupport "documentation")
  ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libffi ]
    ++ optional scannerSupport expat
    ++ optionals documentationSupport [ docbook_xsl doxygen graphviz-nox libxslt xmlto ];

  meta = {
    description = "Reference implementation of the wayland protocol";
    homepage    = http://wayland.freedesktop.org/;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ codyopel wkennington ];
  };
}
