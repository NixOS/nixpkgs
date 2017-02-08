{ callPackage, fetchurl, coq }:

let param =
  let v16 = {
    version = "1.6";
    url = http://ssr.msr-inria.inria.fr/FTP/mathcomp-1.6.tar.gz;
    sha256 = "0adr556032r1jkvphbpfvrrv041qk0yqb7a1xnbam52ji0mdl2w8";
  }; v161 = {
    version = "1.6.1";
    url = https://github.com/math-comp/math-comp/archive/mathcomp-1.6.1.tar.gz;
    sha256 = "1j9ylggjzrxz1i2hdl2yhsvmvy5z6l4rprwx7604401080p5sgjw";
  }; in
{
  "8.4" = v16;
  "8.5" = v16;
  "8.6" = v161;
}."${coq.coq-version}"; in

callPackage ./generic.nix {
  name = "coq${coq.coq-version}-mathcomp-${param.version}";
  src = fetchurl { inherit (param) url sha256; };
}
