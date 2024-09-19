{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  openssl,
  libgcrypt,
  libplist,
  libtasn1,
  libtatsu,
  libusbmuxd,
  libimobiledevice-glue,
  SystemConfiguration,
  CoreFoundation,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libimobiledevice";
  version = "1.3.0-unstable-2024-09-16";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libimobiledevice";
    rev = "ed9703db1ee6d54e3801b618cee9524563d709e1";
    hash = "";
  };

  outputs = [
    "out"
    "dev"
  ];
  enableParallelBuilding = true;
  passthru.updateScript = unstableGitUpdater { };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs =
    [
      openssl
      libgcrypt
      libplist
      libtasn1
      libtatsu
      libusbmuxd
      libimobiledevice-glue
    ]
    ++ lib.optionals stdenv.isDarwin [
      SystemConfiguration
      CoreFoundation
    ];

  configureFlags = [ "--without-cython" ];

  preAutoreconf = ''
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libimobiledevice";
    description = "Software library that talks the protocols to support iPhone®, iPod Touch® and iPad® devices on Linux";
    longDescription = ''
      libimobiledevice is a software library that talks the protocols to support
      iPhone®, iPod Touch® and iPad® devices on Linux. Unlike other projects, it
      does not depend on using any existing proprietary libraries and does not
      require jailbreaking. It allows other software to easily access the
      device's filesystem, retrieve information about the device and it's
      internals, backup/restore the device, manage SpringBoard® icons, manage
      installed applications, retrieve addressbook/calendars/notes and bookmarks
      and synchronize music and video to the device. The library is in
      development since August 2007 with the goal to bring support for these
      devices to the Linux Desktop.
    '';
    license = with licenses; [
      lgpl21
      gpl2
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [
      frontear
      RossComputerGuy
    ];
  };
})
