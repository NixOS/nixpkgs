args: with args;

stdenv.mkDerivation rec {
  name = "kdebase-" + version;

  src = fetchurl {
    url = "mirror://kde/stable/${version}/src/${name}.tar.bz2";
    sha256 = "1cdswhavhk6wjdxwpsmmvq1qqw2a5mdyvvxk9fnxn9fnic7q0603";
  };

  propagatedBuildInputs = [kde4.pimlibs kde4.support.qimageblitz libusb];
  buildInputs = [cmake];
}
