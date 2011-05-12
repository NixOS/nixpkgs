{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mp4v2-1.9.1";

  src = fetchurl {
    url = "http://mp4v2.googlecode.com/files/${name}.tar.bz2";
    sha256 = "1d73qbi0faqad3bpmjfr4kk0mfmqpl1f43ysrx4gq9i3mfp1qf2w";
  };

  # `faac' expects `mp4.h'.
  postInstall = "ln -s mp4v2/mp4v2.h $out/include/mp4.h";

  meta = {
    homepage = http://code.google.com/p/mp4v2;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
