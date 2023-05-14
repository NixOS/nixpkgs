{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, gnutls
, libgcrypt
, libplist
, libtasn1
, libusbmuxd
, libimobiledevice-glue
, SystemConfiguration
, CoreFoundation
}:

stdenv.mkDerivation rec {
  pname = "libimobiledevice";
  version = "1.3.0+date=2022-05-22";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "12394bc7be588be83c352d7441102072a89dd193";
    hash = "sha256-2K4gZrFnE4hlGlthcKB4n210bTK3+6NY4TYVIoghXJM=";
  };

  postPatch = ''
    echo '${version}' > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    gnutls
    libgcrypt
    libplist
    libtasn1
    libusbmuxd
    libimobiledevice-glue
  ] ++ lib.optionals stdenv.isDarwin [
    SystemConfiguration
    CoreFoundation
  ];

  configureFlags = [ "--with-gnutls" "--without-cython" ];

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libimobiledevice";
    description = "A software library that talks the protocols to support iPhone®, iPod Touch® and iPad® devices on Linux";
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
    maintainers = with maintainers; [ infinisil ];
  };
}
