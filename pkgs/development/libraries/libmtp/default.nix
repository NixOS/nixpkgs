{ stdenv
, autoconf
, automake
, fetchFromGitHub
, fetchpatch
, gettext
, lib
, libiconv
, libtool
, libusb1
, pkg-config
, buildPackages
}:

stdenv.mkDerivation rec {
  pname = "libmtp";
  version = "1.1.21";

  src = fetchFromGitHub {
    owner = "libmtp";
    repo = "libmtp";
    rev = "libmtp-${builtins.replaceStrings [ "." ] [ "-" ] version}";
    sha256 = "sha256-m9QFVD8udQ3SdGwn276BnIKqGeATA5QuokOK29Ykc1k=";
  };

  patches = [
    # Backport cross fix.
    (fetchpatch {
      url = "https://github.com/libmtp/libmtp/commit/467fa26e6b14c0884b15cf6d191de97e5513fe05.patch";
      sha256 = "2DrRrdcguJ9su4LxtT6YOjer8gUTxIoHVpk+6M9P4cg=";
    })
  ];

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

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [ "--with-udev=${placeholder "out"}/lib/udev" ];

  configurePlatforms = [ "build" "host" ];

  makeFlags = lib.optionals (stdenv.isLinux && !stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "MTP_HOTPLUG=${buildPackages.libmtp}/bin/mtp-hotplug"
  ];

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
