{stdenv, fetchurl, perl, python, swig, gd, libxml2, tcl, libusb, pkgconfig,
 boost, libtool, perlPackages }:

stdenv.mkDerivation rec {
  pname = "hamlib";
  version = "1.2.15.3";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "0ppp6fc2h9d8p30j2s9wlqd620kmnny4wd8fc3jxd6gxwi4lbjm2";
  };

  buildInputs = [ perl perlPackages.ExtUtilsMakeMaker python swig gd libxml2
                  tcl libusb pkgconfig boost libtool ];

  configureFlags = [ "--with-perl-binding" "--with-python-binding"
                     "--with-tcl-binding" "--with-rigmatrix" ];

  meta = {
    description = "Runtime library to control radio transceivers and receivers";
    longDescription = ''
    Hamlib provides a standardized programming interface that applications
    can use to send the appropriate commands to a radio.

    Also included in the package is a simple radio control program 'rigctl',
    which lets one control a radio transceiver or receiver, either from
    command line interface or in a text-oriented interactive interface.
    '';
    license = with stdenv.lib.licenses; [ gpl2Plus lgpl2Plus ];
    homepage = http://hamlib.sourceforge.net;
    maintainers = with stdenv.lib.maintainers; [ relrod ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
