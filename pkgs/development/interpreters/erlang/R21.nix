{ mkDerivation }:

mkDerivation rec {
  version = "21.2";
  sha256 = "0v9smdp2vxkpsz65a6ypwzl12fqdfrsi7k29f5i7af0v27r308cm";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
  '';
}
