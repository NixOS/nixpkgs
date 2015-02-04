{ stdenv, fetchgit, libtool, autoconf, automake113x, pkgconfig, libusb, glib, nss, nspr, pixman }:

stdenv.mkDerivation rec {
  name = "libfprint";

  src = fetchgit {
    url = "git://anongit.freedesktop.org/libfprint/libfprint";
    rev = "a3c90f2b24434aa36f782aca3950fd89af01fce0";
    sha256 = "01qa58vq299xzxzxrcqkl51k8396wh56674d9wjmkv2msxx877hi";
  };

  buildInputs = [ libusb glib nss nspr pixman ];
  nativeBuildInputs = [ libtool autoconf automake113x pkgconfig ];

  configureScript = "./autogen.sh";

  configureFlags = [ "--prefix=$(out)" "--disable-examples-build" "--disable-x11-examples-build" "--with-udev-rules-dir=$(out)/lib/udev/rules.d" ];

  meta = with stdenv.lib; {
    homepage = "http://www.freedesktop.org/wiki/Software/fprint/libfprint/";
    description = "A library designed to make it easy to add support for consumer fingerprint readers";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
