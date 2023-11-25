{ lib, stdenv, fetchFromGitHub }:

# libhdhomerun requires UDP port 65001 to be open in order to detect and communicate with tuners.
# If your firewall is enabled, make sure to have something like:
#   networking.firewall.allowedUDPPorts = [ 65001 ];

stdenv.mkDerivation rec {
  pname = "libhdhomerun";
  version = "20231109";

  src = fetchFromGitHub {
    owner = "Silicondust";
    repo = "${pname}";
    rev = "e8f29fd4e071580ffb583cbeb9cf720c96a4e75f"; # 20231109
    sha256 = "sha256-ni6bhvTXbFzNnKr6cgG0m7o3JEIDY7jouT88rfSf66A=";
  };

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];
  patches = [ ./nixos-darwin-no-fat-dylib.patch ];

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
    maintainers = [ maintainers.titanous maintainers.sielicki ];
  };
}
