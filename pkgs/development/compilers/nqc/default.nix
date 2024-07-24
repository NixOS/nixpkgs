{ lib, stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "nqc";
  version = "3.1.r6";

  src = fetchurl {
    url = "https://bricxcc.sourceforge.net/nqc/release/nqc-${version}.tgz";
    sha256 = "sha256-v9XmVPY5r3pYjP3vTSK9Xvz/9UexClbOvr3ljvK/52Y=";
  };

  sourceRoot = ".";

  patches = [
    ./nqc-unistd.patch
    (fetchpatch {
      url = "https://sourceforge.net/p/bricxcc/patches/_discuss/thread/00b427dc/b84b/attachment/nqc-01-Linux_usb_and_tcp.diff";
      sha256 = "sha256-UZmmhhhfLAUus36TOBhiDQ8KUeEdYhGHVFwqKqDIqII=";
    })
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  dontConfigure = true;

  meta = with lib; {
    homepage = "https://bricxcc.sourceforge.net/nqc/";
    description = "Programming language for several LEGO MINDSTORMS products including the RCX, CyberMaster, and Scout";
    platforms = platforms.linux;
    license = licenses.mpl10;
    maintainers = with maintainers; [ christophcharles ];
  };
}
