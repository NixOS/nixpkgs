{ mkDerivation }:

mkDerivation rec {
  version = "21.0";
  sha256 = "0khprgawmbdpn9b8jw2kksmvs6b45mibpjralsc0ggxym1397vm8";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
  '';
}
