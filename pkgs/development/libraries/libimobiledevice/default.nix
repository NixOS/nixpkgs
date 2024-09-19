{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,

  autoreconfHook,
  pkg-config,

  libgcrypt,
  libimobiledevice-glue,
  libplist,
  libtasn1,
  libtatsu,
  libusbmuxd,
  openssl,

  CoreFoundation,
  SystemConfiguration,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libimobiledevice";
  version = "1.3.0-unstable-2024-09-16";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libimobiledevice";
    rev = "ed9703db1ee6d54e3801b618cee9524563d709e1";
    hash = "sha256-fdUcEdqrZkiX1QEr9KdKAMJPzpJuboRRpXaQ3vYwspw=";
  };

  enableParallelBuilding = true;
  outputs = [
    "out"
    "dev"
  ];
  passthru.updateScript = unstableGitUpdater { };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs =
    [
      libgcrypt
      libimobiledevice-glue
      libplist
      libtasn1
      libtatsu
      libusbmuxd
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      CoreFoundation
      SystemConfiguration
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
      gpl2Only
      lgpl21Only
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [
      RossComputerGuy
      frontear
    ];
  };
})
