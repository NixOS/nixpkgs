{stdenv, fetchurl, unzip}:

assert unzip != null;

stdenv.mkDerivation {
  name = "docbook-xml-4.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/docbook-xml-4.2.zip;
    md5 = "73fe50dfe74ca631c1602f558ed8961f";
  };
  buildInputs = [unzip];
}
