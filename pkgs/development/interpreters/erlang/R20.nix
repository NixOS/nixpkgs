{ mkDerivation, fetchurl }:

mkDerivation rec {
  version = "20.3.2";
  sha256 = "0cd7rz32cxghxb2q7g3p52sxbhwqn4pkjlf28hy1dms6q7f85zv1";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
  '';
}
