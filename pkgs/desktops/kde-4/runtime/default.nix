args: with args;

stdenv.mkDerivation {
  name = "kdebase-runtime-4.0beta4";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = mirror://kde/unstable/3.95/src/kdebase-runtime-3.95.0.tar.bz2;
    sha256 = "1s4fhbz7gpdxmvlr20c7n6cvcb9sn0qxigzpljsxw9524w177ksr";
  };

  propagatedBuildInputs = [kdepimlibs libusb kdebase xineLib];
  inherit kdelibs;
}

