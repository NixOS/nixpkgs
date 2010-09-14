{ stdenv, fetchurl, help2man }:

stdenv.mkDerivation rec {
  name = "mp4v2-1.9.1";

  buildInputs = [ help2man ];
  src = fetchurl {
    url = "http://mp4v2.googlecode.com/files/${name}.tar.bz2";
    sha256 = "1d73qbi0faqad3bpmjfr4kk0mfmqpl1f43ysrx4gq9i3mfp1qf2w";
  };
}
