args: with args;

stdenv.mkDerivation {
  name = "kdebase-4.0.0";
  #builder = ./builder.sh;

  src = fetchurl {
    url = mirror://kde/stable/4.0.0/src/kdebase-4.0.0.tar.bz2;
    md5 = "01d8f2f16cbd4e225efc996b0dd39769";
  };

  propagatedBuildInputs = [kdepimlibs libusb];
  inherit kdelibs;
}
