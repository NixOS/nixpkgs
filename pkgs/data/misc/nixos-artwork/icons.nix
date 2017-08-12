{ stdenv, fetchFromGitHub, imagemagick }:

stdenv.mkDerivation {
  name = "nixos-icons-2017-03-16";
  srcs = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixos-artwork";
    rev = "783ca1249fc4cfe523ad4e541f37e2229891bc8b";
    sha256 = "0wp08b1gh2chs1xri43wziznyjcplx0clpsrb13wzyscv290ay5a";
  };
  makeFlags = [ "DESTDIR=$(out)" "prefix=" ];
  buildInputs = [ imagemagick ];
}
