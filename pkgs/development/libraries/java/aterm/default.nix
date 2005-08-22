{stdenv, fetchurl, j2sdk, sharedobjects, jjtraveler}:

stdenv.mkDerivation {
  name = "aterm-java-1.6";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/aterm-java-1.6.tar.gz;
    md5 = "abf475dae2f5efca865fcdff871feb5e";
  };
  buildInputs = [stdenv j2sdk sharedobjects jjtraveler];
}
