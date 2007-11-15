args: with args;

stdenv.mkDerivation {
  name = "kdebase-workspace-4.0beta4";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = mirror://kde/unstable/3.95/src/kdebase-workspace-3.95.0.tar.bz2;
    sha256 = "0jripmw8vgs7lxlsif552rr9vqps5kav8jdlfyhmr9c3xw5c99v0";
  };

  buildInputs = [kdelibs kdepimlibs kdebase kderuntime stdenv.gcc.libc];
  inherit kdelibs;
}

