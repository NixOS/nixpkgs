{ lib, stdenv, fetchFromGitHub, autoconf, automake, gettext, libtool, pkg-config
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
    sha256 = "0rya6dsb67a7ny2i1jzdicnday42qb8njqw6r902k712k5p7d1r9";
  };

  outputs = [ "bin" "dev" "out" ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    libtool
    pkg-config
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

  meta = with lib; {
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
