args: with args;

stdenv.mkDerivation {
  name = "kdenetwork-4.0beta4";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.95/src/kdenetwork-3.95.0.tar.bz2;
    sha256 = "118r55aw0pag78kawjfn3vya7aca12n5ypknm1i4khxs747hxqbr";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace sqlite libidn];
}
