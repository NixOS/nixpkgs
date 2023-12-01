{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, openssl
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
  version = "1.3.0+date=2023-04-30";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "860ffb707af3af94467d2ece4ad258dda957c6cd";
    hash = "sha256-mIsB+EaGJlGMOpz3OLrs0nAmhOY1BwMs83saFBaejwc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    openssl
    libgcrypt
    libplist
    libtasn1
    libusbmuxd
    libimobiledevice-glue
  ] ++ lib.optionals stdenv.isDarwin [
    SystemConfiguration
    CoreFoundation
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${version}
  '';

  configureFlags = [ "--without-cython" ];

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
