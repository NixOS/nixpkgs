{ stdenv, fetchFromGitHub, automake, autoconf, libtool, pkgconfig, gnutls
, libgcrypt, libtasn1, glib, libplist, libusbmuxd }:

stdenv.mkDerivation rec {
  pname = "libimobiledevice";
  version = "2020-01-20";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "61babf5f54e7734ebf3044af4c6294524d4b29b5";
    sha256 = "02dnq6xza72li52kk4p2ak0gq2js3ssfp2fpjlgsv0bbn5mkg2hi";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkgconfig
  ];
  propagatedBuildInputs = [
    glib
    gnutls
    libgcrypt
    libplist
    libtasn1
    libusbmuxd
  ];

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [
    "--disable-openssl"
    "--without-cython"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/libimobiledevice/libimobiledevice;
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
    platforms = platforms.linux;
    maintainers = with maintainers; [ infinisil ];
  };
}
