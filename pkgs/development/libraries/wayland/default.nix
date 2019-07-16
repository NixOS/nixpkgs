{ lib, stdenv, fetchurl, pkgconfig
, libffi, libxml2, wayland
, expat ? null # Build wayland-scanner (currently cannot be disabled as of 1.7.0)
}:

# Require the optional to be enabled until upstream fixes or removes the configure flag
assert expat != null;

stdenv.mkDerivation rec {
  pname = "wayland";
  version = "1.17.0";

  src = fetchurl {
    url = "https://wayland.freedesktop.org/releases/${pname}-${version}.tar.xz";
    sha256 = "194ibzwpdcn6fvk4xngr4bf5axpciwg2bj82fdvz88kfmjw13akj";
  };

  separateDebugInfo = true;

  configureFlags = [
    "--disable-documentation"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "--with-host-scanner"
  ];

  nativeBuildInputs = [
    pkgconfig
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    # for wayland-scanner during build
    wayland
  ];

  buildInputs = [ libffi /* docbook_xsl doxygen graphviz libxslt xmlto */ expat libxml2 ];

  meta = {
    description = "Reference implementation of the wayland protocol";
    homepage    = https://wayland.freedesktop.org/;
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ codyopel ];
  };

  passthru.version = version;
}
