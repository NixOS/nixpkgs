{stdenv, fetchurl, perl, zip}:

stdenv.mkDerivation {
  name = "nss-3.10";
  builder = ./builder.sh;

  nsssrc = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/nss-3.10.tar.gz;
    md5 = "f0d75d52aff21f88d9c055bdb78f54f8";
  };

  nsprsrc =  fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/nspr-4.6.tar.gz;
    md5 = "a37c3cde875502e05576429312452465";
  };

  buildInputs = [perl zip];
}
