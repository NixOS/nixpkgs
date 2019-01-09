{ lib, stdenv, fetchurl, pkgconfig
, libffi, libxml2, wayland
, expat ? null # Build wayland-scanner (currently cannot be disabled as of 1.7.0)
}:

# Require the optional to be enabled until upstream fixes or removes the configure flag
assert expat != null;

stdenv.mkDerivation rec {
  name = "wayland-${version}";
  version = "1.16.0";

  src = fetchurl {
    url = "https://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "1xajhxad43izq9f7sbww1hlg42nayijy8xnp21kgpk09c6sw4wjf";
  };

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
    maintainers = with lib.maintainers; [ codyopel wkennington ];
  };

  passthru.version = version;
}
