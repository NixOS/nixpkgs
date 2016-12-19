{ stdenv, fetchurl, coreutils, autoconf, automake, smlnj }:

stdenv.mkDerivation rec {
  name = "manticore-${version}";
  version = "2014.08.18";
  builder = ./builder.sh;
  src = fetchurl {
    url = https://github.com/rrnewton/manticore_temp_mirror/archive/snapshot-20140818.tar.gz; 
    sha256 = "1x52xpj5gbcpqjqm6aw6ssn901f353zypj3d5scm8i3ad777y29d";
  };
  inherit stdenv coreutils autoconf automake smlnj;

  meta = {
    description = "A parallel, pure variant of Standard ML";

    longDescription = '' 
      Manticore is a high-level parallel programming language aimed at
      general-purpose applications running on multi-core
      processors. Manticore supports parallelism at multiple levels:
      explicit concurrency and coarse-grain parallelism via CML-style
      constructs and fine-grain parallelism via various light-weight
      notations, such as parallel tuple expressions and NESL/Nepal-style
      parallel array comprehensions.  
    '';

    homepage = http://manticore.cs.uchicago.edu/;
  };
}
