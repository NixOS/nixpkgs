{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  openssl,
  libgcrypt,
  libplist,
  libtasn1,
  libusbmuxd,
  libimobiledevice-glue,
  SystemConfiguration,
  CoreFoundation,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "libimobiledevice";
  version = "1.3.0-unstable-2024-05-20";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "9ccc52222c287b35e41625cc282fb882544676c6";
    hash = "sha256-pNvtDGUlifp10V59Kah4q87TvLrcptrCJURHo+Y+hs4=";
  };

  patches = [
    # Fix gcc-14 and clang-16 build:
    #   https://github.com/libimobiledevice/libimobiledevice/pull/1569
    (fetchpatch {
      name = "fime.h.patch";
      url = "https://github.com/libimobiledevice/libimobiledevice/commit/92256c2ae2422dac45d8648a63517598bdd89883.patch";
      hash = "sha256-sB+wEFuXFoQnuf7ntWfvYuCgWfYbmlPL7EjW0L0F74o=";
    })
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${version}
  '';

  configureFlags = [ "--without-cython" ];

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
      libusbmuxd
      libimobiledevice-glue
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      SystemConfiguration
      CoreFoundation
    ];

  outputs = [
    "out"
    "dev"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = unstableGitUpdater { };

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
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ RossComputerGuy ];
  };
}
