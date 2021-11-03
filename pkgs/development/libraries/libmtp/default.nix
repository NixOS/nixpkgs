{ stdenv
, autoconf
, automake
, fetchFromGitHub
, gettext
, lib
, libiconv
, libtool
, libusb1
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libmtp";
  version = "1.1.19";

  src = fetchFromGitHub {
    owner = "libmtp";
    repo = "libmtp";
    rev = "libmtp-${builtins.replaceStrings [ "." ] [ "-" ] version}";
    sha256 = "sha256-o8JKoKVNpU/nHTDnKJpa8FlXt37fZnTf45WBTCxLyTs=";
  };

  outputs = [ "bin" "dev" "out" ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    libtool
    pkg-config
  ];

  buildInputs = [ libiconv ];

  propagatedBuildInputs = [ libusb1 ];

  preConfigure = "./autogen.sh";

  configureFlags = [ "--with-udev=${placeholder "out"}/lib/udev" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/libmtp/libmtp";
    description = "An implementation of Microsoft's Media Transfer Protocol";
    longDescription = ''
      libmtp is an implementation of Microsoft's Media Transfer Protocol (MTP)
      in the form of a library suitable primarily for POSIX compliant operating
      systems. We implement MTP Basic, the stuff proposed for standardization.
    '';
    platforms = platforms.unix;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
