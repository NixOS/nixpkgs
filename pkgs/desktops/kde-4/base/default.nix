args: with args;

stdenv.mkDerivation {
  name = "kdebase-4.0rc2";

  src = fetchurl {
    url = mirror://kde/unstable/3.97/src/kdebase-3.97.0.tar.bz2;
    sha256 = "1iavkzfq7f9308j2r70xd6qfng0fncpww8s49hbigzkkdzrjk8gn";
  };

  propagatedBuildInputs = [kdepimlibs libusb];
}
