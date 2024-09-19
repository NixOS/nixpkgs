{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,

  autoreconfHook,
  pkg-config,

  libimobiledevice-glue,
  libusb1,
  readline,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libirecovery";
  version = "1.2.1-unstable-2024-10-10";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libirecovery";
    rev = "2fb767d784c01269a0ded5bacd5539aee3768c35";
    hash = "sha256-R+oBC7F4op0qoIk3d/WqS4MwzZY3WMAMIqlJfJb188Q=";
  };

  outputs = [
    "out"
    "dev"
  ];
  passthru.updateScript = unstableGitUpdater { };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libimobiledevice-glue
    libusb1
    readline
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
    platforms = platforms.unix;
    maintainers = with maintainers; [
      frontear
      nh2
    ];
    mainProgram = "irecovery";
  };
})
