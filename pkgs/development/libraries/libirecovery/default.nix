{ stdenv, fetchFromGitHub, automake, autoconf, libtool, pkgconfig
, libusb
, readline
}:

stdenv.mkDerivation rec {
  pname = "libirecovery";
  version = "2020-01-14";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "10a1f8dd11a11a0b8980fbf26f11e3ce74e7a923";
    sha256 = "1v5c9dbbkrsplj1zkcczzm0i31ar3wcx6fpxb0pi4dsgj8846aic";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkgconfig
  ];

  buildInputs = [
    libusb
    readline
  ];

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  # Packager note: Not clear whether this needs a NixOS configuration,
  # as only the `idevicerestore` binary was tested so far (which worked
  # without further configuration).
  configureFlags = [
    "--with-udevrulesdir=${placeholder "out"}/lib/udev/rules.d"
    ''--with-udevrule="OWNER=\"root\", GROUP=\"myusergroup\", MODE=\"0660\""''
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/libimobiledevice/libirecovery;
    description = "Library and utility to talk to iBoot/iBSS via USB on Mac OS X, Windows, and Linux";
    longDescription = ''
      libirecovery is a cross-platform library which implements communication to
      iBoot/iBSS found on Apple's iOS devices via USB. A command-line utility is also
      provided.
    '';
    license = licenses.lgpl21;
    # Upstream description says it works on more platforms, but packager hasn't tried that yet
    platforms = platforms.linux;
    maintainers = with maintainers; [ nh2 ];
  };
}
