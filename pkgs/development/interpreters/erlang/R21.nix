{ mkDerivation }:

mkDerivation rec {
  version = "21.1.2";
  sha256 = "0kn6ghr151b1qmbazc1c8k1r0wpsrqh9l3wrhfyxix3ld5yc3a5c";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
  '';
}
