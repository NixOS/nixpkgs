{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libusb1,
  readline,
  libimobiledevice-glue,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libirecovery";
  version = "1.2.0-unstable-2024-03-24";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libirecovery";
    rev = "2254dab893ec439f9a73235ea07194afa77399db";
    hash = "";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libusb1
    readline
    libimobiledevice-glue
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  # Packager note: Not clear whether this needs a NixOS configuration,
  # as only the `idevicerestore` binary was tested so far (which worked
  # without further configuration).
  configureFlags = [
    "--with-udevrulesdir=${placeholder "out"}/lib/udev/rules.d"
    ''--with-udevrule="OWNER=\"root\", GROUP=\"myusergroup\", MODE=\"0660\""''
  ];

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libirecovery";
    description = "Library and utility to talk to iBoot/iBSS via USB on Mac OS X, Windows, and Linux";
    longDescription = ''
      libirecovery is a cross-platform library which implements communication to
      iBoot/iBSS found on Apple's iOS devices via USB. A command-line utility is also
      provided.
    '';
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [
      frontear
      nh2
    ];
    platforms = platforms.unix;
    mainProgram = "irecovery";
  };
})
