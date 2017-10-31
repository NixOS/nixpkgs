{ stdenv, fetchpatch, fetchFromGitHub, pkgconfig, libusb1, libtool, libexif, libjpeg, gettext, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libgphoto2-${meta.version}";

  src = fetchFromGitHub {
    owner = "gphoto";
    repo = "libgphoto2";
    rev = "${meta.tag}";
    sha256 = "0chwnw3d2d1k8g4xidzkpy9f3ci30yz7yvxq1mipp2rbndl1y2am";
  };

  patches = [];

  nativeBuildInputs = [ pkgconfig gettext autoreconfHook ];
  buildInputs = [ libtool libjpeg libusb1  ];

  # These are mentioned in the Requires line of libgphoto's pkg-config file.
  propagatedBuildInputs = [ libexif ];

  hardeningDisable = [ "format" ];

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    $out/lib/libgphoto2/print-camera-list udev-rules version 175 group camera >$out/lib/udev/rules.d/40-gphoto2.rules
  '';

  meta = {
    homepage = http://www.gphoto.org/proj/libgphoto2/;
    description = "A library for accessing digital cameras";
    longDescription = ''
      This is the library backend for gphoto2. It contains the code for PTP,
      MTP, and other vendor specific protocols for controlling and transferring data
      from digital cameras.
    '';
    version = "2.5.12";
    tag = "libgphoto2-2_5_12-release";
    # XXX: the homepage claims LGPL, but several src files are lgpl21Plus
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = with stdenv.lib.platforms; unix;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
