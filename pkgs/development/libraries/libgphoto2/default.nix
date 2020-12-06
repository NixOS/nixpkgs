{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gettext
, libusb1
, libtool
, libexif
, libjpeg
}:

stdenv.mkDerivation rec {
  pname = "libgphoto2";
  version = "2.5.23";

  src = fetchFromGitHub {
    owner = "gphoto";
    repo = "libgphoto2";
    rev = "libgphoto2-${builtins.replaceStrings [ "." ] [ "_" ] version}-release";
    sha256 = "1sc2ycx11khf0qzp1cqxxx1qymv6bjfbkx3vvbwz6wnbyvsigxz2";
  };

  patches = [];

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
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
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = with stdenv.lib.platforms; unix;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
