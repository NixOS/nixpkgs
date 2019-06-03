{ mkDerivation }:

mkDerivation rec {
  version = "21.3.8.2";
  sha256 = "1jpqvgi4m1mk9xk7m6264dp5b8hk4xipx4jg8vj7bhm0dxvq3mir";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
  '';
}
