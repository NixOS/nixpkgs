{ stdenv, fetchurl }:

# this expression is mostly based on debian's packaging
# https://tracker.debian.org/media/packages/u/udns/rules-0.4-1

stdenv.mkDerivation rec {
  name = "udns-${version}";
  version = "0.4";

  configurePhase = "./configure --enable-ipv6";

  buildPhase = "make staticlib sharedlib rblcheck_s dnsget_s";

  src = fetchurl {
    url = "http://www.corpit.ru/mjt/udns/${name}.tar.gz";
    sha256 = "0447fv1hmb44nnchdn6p5pd9b44x8p5jn0ahw6crwbqsg7f0hl8i";
  };

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/include
    mkdir -p $out/lib
    mkdir -p $out/share/man/man1
    mkdir -p $out/share/man/man3
    cp dnsget_s $out/bin/dnsget
    cp rblcheck_s $out/bin/rblcheck
    cp udns.h $out/include/
    cp libudns.a $out/lib/
    cp libudns.so.0 $out/lib/
    ln -rs $out/lib/libudns.so.0 $out/lib/libudns.so
    cp dnsget.1 rblcheck.1 $out/share/man/man1
    cp udns.3 $out/share/man/man3
  '';

  # keep man3
  outputDevdoc = "out";

  meta = with stdenv.lib; {
    homepage = http://www.corpit.ru/mjt/udns.html;
    description = "Async-capable DNS stub resolver library";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
