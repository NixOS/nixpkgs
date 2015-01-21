{ stdenv, fetchgit, libtool, autoconf, automake113x, pkgconfig, libusb, glib, nss, nspr, pixman }:

stdenv.mkDerivation rec {
  name = "libfprint";

  src = fetchgit {
    url = "git://anongit.freedesktop.org/libfprint/libfprint";
    rev = "35e356f625d254f44c14f720c0eb9216297d35c2";
    sha256 = "b7fd74a914d7c4e2999ac20432a7f2af5d6c7af5e75a367bc3babe03e4576c86";
  };

  patches = [ ./0001-lib-Add-VFS5011-driver.patch ];

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
