{ callPackage, fetchurl, coq }:

if coq.coq-version == "8.4" then

callPackage ./generic.nix {

  name = "coq-mathcomp-1.6-${coq.coq-version}";
  src = fetchurl {
    url = http://ssr.msr-inria.inria.fr/FTP/mathcomp-1.6.tar.gz;
    sha256 = "0adr556032r1jkvphbpfvrrv041qk0yqb7a1xnbam52ji0mdl2w8";
  };

}

else if coq.coq-version == "8.5" then

callPackage ./generic.nix {

  name = "coq-mathcomp-1.6-${coq.coq-version}";
  src = fetchurl {
    url = http://ssr.msr-inria.inria.fr/FTP/mathcomp-1.6.tar.gz;
    sha256 = "0adr556032r1jkvphbpfvrrv041qk0yqb7a1xnbam52ji0mdl2w8";
  };

}

else if coq.coq-version == "8.6" then

callPackage ./generic.nix {

  name = "coq-mathcomp-1.6.1-${coq.coq-version}";
  src = fetchurl {
    url = https://github.com/math-comp/math-comp/archive/mathcomp-1.6.1.tar.gz;
    sha256 = "1j9ylggjzrxz1i2hdl2yhsvmvy5z6l4rprwx7604401080p5sgjw";
  };

}

else throw "No ssreflect package for Coq version ${coq.coq-version}"
