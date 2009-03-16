args: with args;

stdenv.mkDerivation {
  name = "kdebase-workspace-4.0.0";
  builder = ./builder.sh;

  src = fetchurl {
    url = mirror://kde/stable/4.0.0/src/kdebase-workspace-4.0.0.tar.bz2;
    md5 = "f3d2155ff5ff7472a8884bd3f31bff16";
  };

  buildInputs = [kdelibs kdepimlibs kdebase kderuntime stdenv.gcc.libc];
  inherit kdelibs;
}

