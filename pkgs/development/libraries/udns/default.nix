{ lib, stdenv, fetchurl }:

# this expression is mostly based on debian's packaging
# https://tracker.debian.org/media/packages/u/udns/rules-0.6-1

stdenv.mkDerivation rec {
  pname = "udns";
  version = "0.6";

  configurePhase = "./configure --enable-ipv6";

  buildPhase = "make staticlib sharedlib rblcheck_s dnsget_s";

  src = fetchurl {
    url = "http://www.corpit.ru/mjt/udns/${pname}-${version}.tar.gz";
    sha256 = "sha256-aWotDVGNqYXZdaZeEdFm8/V829HUI3aguFMH9JYBxug=";
  };

  # udns uses a very custom build and hardcodes a .so name in a few places.
  # Instead of fighting with it to apply the standard dylib script, change
  # the right place in the Makefile itself.
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile.in \
      --replace --soname, -install_name,$out/lib/
  '';

  installPhase = ''
    runHook preInstall
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
    runHook postInstall
  '';

  # keep man3
  outputDevdoc = "out";

  meta = with lib; {
    homepage = "http://www.corpit.ru/mjt/udns.html";
    description = "Async-capable DNS stub resolver library";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.unix;
  };

}
