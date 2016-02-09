{ callPackage, coq, fetchurl }:

let src = 
  if coq.coq-version == "8.4" then

    fetchurl {
      url = http://ssr.msr-inria.inria.fr/FTP/mathcomp-1.6.tar.gz;
      sha256 = "0adr556032r1jkvphbpfvrrv041qk0yqb7a1xnbam52ji0mdl2w8";
    }

  else if coq.coq-version == "8.5" then

    fetchurl {
      url = http://ssr.msr-inria.inria.fr/FTP/mathcomp-1.6.tar.gz;
      sha256 = "0adr556032r1jkvphbpfvrrv041qk0yqb7a1xnbam52ji0mdl2w8";
    }

  else throw "No mathcomp package for Coq version ${coq.coq-version}";

in

callPackage ./generic.nix {
  inherit src;
}
