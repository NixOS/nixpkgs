{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
<<<<<<< HEAD
, openssl
=======
, gnutls
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "1.3.0+date=2023-04-30";
=======
  version = "1.3.0+date=2022-05-22";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
<<<<<<< HEAD
    rev = "860ffb707af3af94467d2ece4ad258dda957c6cd";
    hash = "sha256-mIsB+EaGJlGMOpz3OLrs0nAmhOY1BwMs83saFBaejwc=";
  };

=======
    rev = "12394bc7be588be83c352d7441102072a89dd193";
    hash = "sha256-2K4gZrFnE4hlGlthcKB4n210bTK3+6NY4TYVIoghXJM=";
  };

  postPatch = ''
    echo '${version}' > .tarball-version
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
<<<<<<< HEAD
    openssl
=======
    gnutls
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    libgcrypt
    libplist
    libtasn1
    libusbmuxd
    libimobiledevice-glue
  ] ++ lib.optionals stdenv.isDarwin [
    SystemConfiguration
    CoreFoundation
  ];

<<<<<<< HEAD
  preAutoreconf = ''
    export RELEASE_VERSION=${version}
  '';

  configureFlags = [ "--without-cython" ];
=======
  configureFlags = [ "--with-gnutls" "--without-cython" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
