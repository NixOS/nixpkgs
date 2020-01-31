{ lib, stdenv, fetchurl, meson, pkgconfig, ninja
, libffi, libxml2, wayland
, expat ? null # Build wayland-scanner (currently cannot be disabled as of 1.7.0)
}:

# Require the optional to be enabled until upstream fixes or removes the configure flag
assert expat != null;

stdenv.mkDerivation rec {
  pname = "wayland";
  version = "1.18.0";

  src = fetchurl {
    url = "https://wayland.freedesktop.org/releases/${pname}-${version}.tar.xz";
    sha256 = "0k995rn96xkplrapz5k648j651wc43kq817xk1x8280h16gsfxa6";
  };

  separateDebugInfo = true;

  mesonFlags = [ "-Ddocumentation=false" ];

  nativeBuildInputs = [
    meson pkgconfig ninja
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    # for wayland-scanner during build
    wayland
  ];

  buildInputs = [ libffi /* docbook_xsl doxygen graphviz libxslt xmlto */ expat libxml2 ];

  meta = {
    description = "Core Wayland window system code and protocol";
    longDescription = ''
      Wayland is a project to define a protocol for a compositor to talk to its
      clients as well as a library implementation of the protocol.
      The wayland protocol is essentially only about input handling and buffer
      management, but also handles drag and drop, selections, window management
      and other interactions that must go through the compositor (but not
      rendering).
    '';
    homepage    = https://wayland.freedesktop.org/;
    license     = lib.licenses.mit; # Expat version
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ primeos codyopel ];
  };

  passthru.version = version;
}
