{ stdenv, fetchFromGitHub, automake, autoconf, libtool, pkgconfig
, libusb
, readline
}:

stdenv.mkDerivation rec {
  pname = "libirecovery";
  version = "2019-01-28";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "5da2a0d7d60f79d93c283964888c6fbbc17be1a3";
    sha256 = "0fqmr1h4b3qn608dn606y7aqv3bsm949gx72b5d6433xlw9b23n8";
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
    "--with-udevrulesdir=${placeholder ''out''}/lib/udev/rules.d"
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
