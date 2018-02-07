{ mkDerivation, fetchurl }:

mkDerivation rec {
  version = "20.2.2";
  sha256 = "1cns1qcmmr00nyvcvcj4p4n2gvliyjynlwfqc7qzpkjjnkb7fzl6";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
  '';
}
