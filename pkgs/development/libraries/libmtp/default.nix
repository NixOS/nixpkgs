{ stdenv, fetchFromGitHub, autoconf, automake, gettext, libtool, pkgconfig
, libusb1
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "libmtp";
  version = "1.1.18";

  src = fetchFromGitHub {
    owner = "libmtp";
    repo = "libmtp";
    rev = "libmtp-${builtins.replaceStrings [ "." ] [ "-" ] version}";
    sha256 = "0lniy0xq397zddlhsv6n4qjn0wwakli5p3ydzxmbzn0z0jgngjja";
  };

  outputs = [ "bin" "dev" "out" ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    libtool
    pkgconfig
  ];

  buildInputs = [
    libiconv
  ];

  propagatedBuildInputs = [
    libusb1
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  # tried to install files to /lib/udev, hopefully OK
  configureFlags = [ "--with-udev=$$bin/lib/udev" ];

  meta = with stdenv.lib; {
    homepage = "http://libmtp.sourceforge.net";
    description = "An implementation of Microsoft's Media Transfer Protocol";
    longDescription = ''
      libmtp is an implementation of Microsoft's Media Transfer Protocol (MTP)
      in the form of a library suitable primarily for POSIX compliant operating
      systems. We implement MTP Basic, the stuff proposed for standardization.
      '';
    platforms = platforms.unix;
    license = licenses.lgpl21;
  };
}
