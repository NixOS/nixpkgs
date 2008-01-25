args: with args;

stdenv.mkDerivation {
  name = "kdebase-4.0.0";

  src = fetchurl {
    url = mirror://kde/stable/4.0.0/src/kdebase-4.0.0.tar.bz2;
    sha256 = "1419zijcrx6nk10nay3dbv0vi8525hzcqkm2fw8cvw11i4mk909q";
  };

  propagatedBuildInputs = [kdepimlibs libusb];
  buildInputs = [cmake];
}
