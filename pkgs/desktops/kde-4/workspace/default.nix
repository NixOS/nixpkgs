args: with args;

stdenv.mkDerivation {
  name = "kdebase-workspace-4.0rc2";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = mirror://kde/unstable/3.97/src/kdebase-workspace-3.97.0.tar.bz2;
    sha256 = "1sb3vm5y50af6qvsg4sjw14z7y4j1zbgp7w8gsffigbr0hyj4apl";
  };

  buildInputs = [kdelibs kdepimlibs stdenv.gcc.libc];
}
