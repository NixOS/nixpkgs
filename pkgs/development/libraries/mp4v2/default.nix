{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mp4v2-1.9.1p4";

  src = fetchurl {
    url = "http://mp4v2.googlecode.com/files/${name}.tar.bz2";
    sha256 = "1d73qbi0faqad3bpmjfr4kk0mfmqpl1f43ysrx4gq9i3mfp1qf2w";
  };

  # From Handbrake
  # mp4v2 doesn't seem to be actively maintained any more :-/
  patches = [
    ./A00-nero-vobsub.patch ./A01-divide-zero.patch ./A02-meaningful-4gb-warning.patch
    ./P00-mingw-dllimport.patch
  ];
  # `faac' expects `mp4.h'.
  postInstall = "ln -s mp4v2/mp4v2.h $out/include/mp4.h";

  hardeningDisable = [ "format" ];

  meta = {
    homepage = http://code.google.com/p/mp4v2;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
