{ callPackage, coq, fetchurl }:

let src = 
  if coq.coq-version == "8.4" then

    fetchurl {
      url = http://ssr.msr-inria.inria.fr/FTP/mathcomp-1.5.tar.gz;
      sha256 = "1297svwi18blrlyd8vsqilar2h5nfixlvlifdkbx47aljq4m5bam";
    }

  else if coq.coq-version == "8.5" then

    fetchurl {
      url = http://ssr.msr-inria.inria.fr/FTP/mathcomp-1.5.coq85beta2.tar.gz;
      sha256 = "03bnq44ym43x8shi7whc02l0g5vy6rx8f1imjw478chlgwcxazqy";
    }

  else throw "No mathcomp package for Coq version ${coq.coq-version}";

in

callPackage ./generic.nix {
  inherit src;
}
