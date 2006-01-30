{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libmspack-0.0.20040308alpha";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libmspack-0.0.20040308alpha.tar.gz;
    md5 = "4d8e967649df0f6ade83df7da4b7511c";
  };
}
