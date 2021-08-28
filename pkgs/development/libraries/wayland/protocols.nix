{ lib, stdenv, fetchurl, wayland-scanner }:

stdenv.mkDerivation rec {
  pname = "wayland-protocols";
  version = "1.21";

  src = fetchurl {
    url = "https://wayland.freedesktop.org/releases/${pname}-${version}.tar.xz";
    sha256 = "1rfdlkzz67qsb955zqb8jbw3m22pl6ppvrvfq8bqiqcb5n24b6dr";
  };

  nativeBuildInputs = [ wayland-scanner ];

  meta = {
    description = "Wayland protocol extensions";
    longDescription = ''
      wayland-protocols contains Wayland protocols that add functionality not
      available in the Wayland core protocol. Such protocols either add
      completely new functionality, or extend the functionality of some other
      protocol either in Wayland core, or some other protocol in
      wayland-protocols.
    '';
    homepage    = "https://gitlab.freedesktop.org/wayland/wayland-protocols";
    license     = lib.licenses.mit; # Expat version
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ primeos ];
  };

  passthru.version = version;
}
