{stdenv, fetchgit, python, autoconf, automake, libtool, pygobject, pkgconfig, udev}:

stdenv.mkDerivation {
  name = "python-gudev-147.2";
  src = fetchgit {
    url = git://github.com/nzjrs/python-gudev.git;
    rev = "refs/tags/147.2";
    sha256 = "5b9766fcb88855a77ac8bb416ca3b51f55ac7d82b0e189f88c59cacb11586c15";
  };

  buildInputs = [ python autoconf automake libtool pygobject pkgconfig udev ];

  preConfigure = ''
    sed -e 's@/usr/bin/file@file@g' -i configure.ac
    sh autogen.sh
  '';

  meta = {
    homepage = http://www.freedesktop.org/software/systemd/gudev/;
    description = "Python binding to the GUDev udev helper library.";
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [qknight];
    platforms = with stdenv.lib.platforms; all;
  };
}
