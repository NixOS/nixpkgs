{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, pcsclite, libusb
, doxygen, libxslt
}:

stdenv.mkDerivation rec {
  name = "openct-${version}";
  version = "0.6.20";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "openct";
    rev = name;
    sha256 = "09wxq0jxdxhci3zr7jd3zcxjkl3j0r1v00k3q8gqrg9gighh8nk2";
  };

  postPatch = ''
    sed -i 's,$(DESTDIR),$(out),g' etc/Makefile.am
  '';

  configureFlags = [
    "--enable-api-doc"
    "--enable-usb"
    "--enable-pcsc"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ pcsclite libusb doxygen libxslt ];

  preInstall = ''
    mkdir -p $out/etc
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/OpenSC/openct/;
    license = licenses.lgpl21;
    description = "Drivers for several smart card readers";
    platforms = platforms.all;
  };
}
