{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "sqlite-2.8.16";

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/sqlite-2.8.16.tar.gz;
    md5 = "9c79b461ff30240a6f9d70dd67f8faea";
  };
}
