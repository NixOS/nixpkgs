args: with args;

stdenv.mkDerivation {
  name = "kdebase-4.0beta4";
  #builder = ./builder.sh;
  
  src = fetchurl {
    url = mirror://kde/unstable/3.95/src/kdebase-3.95.0.tar.bz2;
    sha256 = "0qf7bn5jqj70hznjk74vpwb7rvk6f5gx9fxwli930b2hskib3zll";
  };

  propagatedBuildInputs = [kdepimlibs libusb];
  inherit kdelibs;
}
