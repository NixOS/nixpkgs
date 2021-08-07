{ lib, stdenv, fetchurl }:

# libhdhomerun requires UDP port 65001 to be open in order to detect and communicate with tuners.
# If your firewall is enabled, make sure to have something like:
#   networking.firewall.allowedUDPPorts = [ 65001 ];

stdenv.mkDerivation rec {
  pname = "libhdhomerun";
  version = "20210624";

  src = fetchurl {
    url = "https://download.silicondust.com/hdhomerun/libhdhomerun_${version}.tgz";
    sha256 = "sha256-3q9GO7zD7vpy+XGZ77YhP3sOLI6R8bPSy/UgVqhxXRU=";
  };

  patchPhase = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile --replace "gcc" "cc"
    substituteInPlace Makefile --replace "-arch i386" ""
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib,include/hdhomerun}
    install -Dm444 libhdhomerun${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib
    install -Dm555 hdhomerun_config $out/bin
    cp *.h $out/include/hdhomerun
  '';

  meta = with lib; {
    description = "Implements the libhdhomerun protocol for use with Silicondust HDHomeRun TV tuners";
    homepage = "https://www.silicondust.com/support/linux";
    license = licenses.lgpl21Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.titanous ];
  };
}
