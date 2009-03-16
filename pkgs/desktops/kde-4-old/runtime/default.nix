args: with args;

stdenv.mkDerivation {
  name = "kdebase-runtime-4.0.0";
  builder = ./builder.sh;

  src = fetchurl {
    url = mirror://kde/stable/4.0.0/src/kdebase-runtime-4.0.0.tar.bz2;
    md5 = "da93f59497ff90ad01bd4ab9b458f6cb";
  };

  propagatedBuildInputs = [kdepimlibs libusb kdebase xineLib];
  inherit kdelibs;
}

