{stdenv, fetchurl, patchelf, libusb}:

assert stdenv ? cc && stdenv.cc.libc != null;

stdenv.mkDerivation rec {
  name = "scmccid-5.0.11";

  src = if stdenv.system == "i686-linux" then (fetchurl {
      url = "http://www.scmmicro.com/support/download/scmccid_5.0.11_linux.tar.gz";
      sha256 = "1r5wkarhzl09ncgj55baizf573czw0nplh1pgddzx9xck66kh5bm";
    })
    else if stdenv.system == "x86_64-linux" then (fetchurl {
        url = "http://www.scmmicro.com/support/download/scmccid_5.0.11_linux_x64.tar.gz";
        sha256 = "0k9lzlk01sl4ycfqgrqqy3bildz0mcr1r0kkicgjz96l4s0jgz0i";
    })
    else throw "Architecture not supported";

  buildInputs = [ patchelf ];

  installPhase = ''
    RPATH=${libusb.out}/lib:${stdenv.cc.libc.out}/lib

    for a in proprietary/*/Contents/Linux/*.so*; do
        if ! test -L $a; then
            patchelf --set-rpath $RPATH $a
        fi
    done

    mkdir -p $out/pcsc/drivers
    cp -R proprietary/* $out/pcsc/drivers
  '';

  meta = {
    homepage = http://www.scmmicro.com/support/pc-security-support/downloads.html;
    description = "PCSC drivers for linux, for the SCM SCR3310 v2.0 card and others";
    license = stdenv.lib.licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
