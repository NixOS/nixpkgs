{
  lib,
  stdenv,
  fetchurl,
  patchelf,
  libusb-compat-0_1,
}:

assert stdenv ? cc && stdenv.cc.libc != null;

stdenv.mkDerivation rec {
  pname = "scmccid";
  version = "5.0.11";

  src =
    if stdenv.hostPlatform.system == "i686-linux" then
      (fetchurl {
        url = "http://www.scmmicro.com/support/download/scmccid_${version}_linux.tar.gz";
        sha256 = "1r5wkarhzl09ncgj55baizf573czw0nplh1pgddzx9xck66kh5bm";
      })
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      (fetchurl {
        url = "http://www.scmmicro.com/support/download/scmccid_${version}_linux_x64.tar.gz";
        sha256 = "0k9lzlk01sl4ycfqgrqqy3bildz0mcr1r0kkicgjz96l4s0jgz0i";
      })
    else
      throw "Architecture not supported";

  nativeBuildInputs = [ patchelf ];

  installPhase = ''
    RPATH=${libusb-compat-0_1.out}/lib:${stdenv.cc.libc.out}/lib

    for a in proprietary/*/Contents/Linux/*.so*; do
        if ! test -L $a; then
            patchelf --set-rpath $RPATH $a
        fi
    done

    mkdir -p $out/pcsc/drivers
    cp -R proprietary/* $out/pcsc/drivers
  '';

  meta = {
    homepage = "http://www.scmmicro.com/support/pc-security-support/downloads.html";
    description = "PCSC drivers for linux, for the SCM SCR3310 v2.0 card and others";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ viric ];
    platforms = with lib.platforms; linux;
  };
}
