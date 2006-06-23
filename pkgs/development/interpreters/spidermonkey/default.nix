{stdenv, fetchurl, gcc}:

stdenv.mkDerivation {
  name = "spidermonkey-1.5";
  src = fetchurl {
    url = http://ftp.uni-erlangen.de/pub/mozilla.org/js/js-1.5.tar.gz;
    md5 = "863bb6462f4ce535399a7c6276ae6776";
  };

  builder = ./builder.sh;

  NIX_GCC = gcc; # remove when the "internal compiler error" in gcc 4.1.x is fixed
}
