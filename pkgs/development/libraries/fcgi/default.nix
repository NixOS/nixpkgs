{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "fcgi-${version}";
  version = "2.4.0";

  src = fetchurl {
    url = "https://launchpad.net/debian/+archive/primary/+files/libfcgi_${version}.orig.tar.gz";
    #    url = "http://www.fastcgi.com/dist/${name}.tar.gz";
    sha256 = "1f857wnl1d6jfrgfgfpz3zdaj8fch3vr13mnpcpvy8bang34bz36";
  };

  patches = [
    ./gcc-4.4.diff
    (fetchpatch {
      # Fix a stack-smashing bug:
      # xhttps://bugs.debian.org/cgi-bin/bugreport.cgi?bug=681591
      url = "https://bugs.launchpad.net/ubuntu/+source/libfcgi/+bug/933417/+attachment/2745025/+files/poll.patch";
      sha256 = "0v3gw0smjvrxh1bv3zx9xp633gbv5dd5bcn3ipj6ckqjyv4i6i7m";
    })
  ];

  postInstall = "ln -s . $out/include/fastcgi";

  meta = with stdenv.lib; {
    description = "A language independent, scalable, open extension to CG";
    homepage = http://www.fastcgi.com/;
    license = "FastCGI see LICENSE.TERMS";
    platforms = platforms.all;
  };
}
