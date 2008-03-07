args: with args;

stdenv.mkDerivation {
  name = "atk-1.20.0";
  src = fetchurl {
    url = mirror://gnome/sources/atk/1.20/atk-1.20.0.tar.bz2;
    sha256 = "1ja76wd40ibmvgqhl2rnwk217znb7rnccw29jah8s3avpcn2yfqz";
  };
  buildInputs = [pkgconfig perl];
  propagatedBuildInputs = [glib];
}
