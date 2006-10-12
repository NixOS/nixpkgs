{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "unixODBC-2.2.11";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/unixODBC-2.2.11.tar.gz;
    md5 = "9ae806396844e38244cf65ad26ba0f23";
  };
  configureFlags = "--disable-gui";
}
