{ callPackage, fetchurl, coq }:

if coq.coq-version == "8.4" then

callPackage ./generic.nix {

  src = fetchurl {
    url = http://ssr.msr-inria.inria.fr/FTP/ssreflect-1.5.tar.gz;
    sha256 = "0hm1ha7sxqfqhc7iwhx6zdz3nki4rj5nfd3ab24hmz8v7mlpinds";
  };

}

else if coq.coq-version == "8.5" then

callPackage ./generic.nix {

  src = fetchurl {
    url = http://ssr.msr-inria.inria.fr/FTP/ssreflect-1.5.coq85beta2.tar.gz;
    sha256 = "084l9xd5vgb8jml0dkm66g8cil5rsf04w821pjhn2qk9mdbwaagf";
  };

  patches = [ ./threads.patch ];

}

else throw "No ssreflect package for Coq version ${coq.coq-version}"
