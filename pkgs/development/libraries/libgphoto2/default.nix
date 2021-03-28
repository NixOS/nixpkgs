{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, gettext
, libusb1
, libtool
, libexif
, libjpeg
}:

stdenv.mkDerivation rec {
  pname = "libgphoto2";
  version = "2.5.27";

  src = fetchFromGitHub {
    owner = "gphoto";
    repo = "libgphoto2";
    rev = "libgphoto2-${builtins.replaceStrings [ "." ] [ "_" ] version}-release";
    sha256 = "sha256-c7fBl6GBLAU+RL5WFC4PL+n/nEHZUfqIJ9qq1+qNNCg=";
  };

  patches = [];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gettext
    libtool
  ];

  buildInputs = [
    libjpeg
    libusb1
  ];

  # These are mentioned in the Requires line of libgphoto's pkg-config file.
  propagatedBuildInputs = [ libexif ];

  hardeningDisable = [ "format" ];

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    $out/lib/libgphoto2/print-camera-list udev-rules version 175 group camera >$out/lib/udev/rules.d/40-gphoto2.rules
  '';

  meta = {
    homepage = "http://www.gphoto.org/proj/libgphoto2/";
    description = "A library for accessing digital cameras";
    longDescription = ''
      This is the library backend for gphoto2. It contains the code for PTP,
      MTP, and other vendor specific protocols for controlling and transferring data
      from digital cameras.
    '';
    # XXX: the homepage claims LGPL, but several src files are lgpl21Plus
    license = lib.licenses.lgpl21Plus;
    platforms = with lib.platforms; unix;
    maintainers = with lib.maintainers; [ jcumming ];
  };
}
