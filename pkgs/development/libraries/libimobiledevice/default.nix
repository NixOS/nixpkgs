{ stdenv, fetchFromGitHub, automake, autoconf, libtool, pkgconfig, gnutls
, libgcrypt, libtasn1, glib, libplist, libusbmuxd }:

stdenv.mkDerivation rec {
  pname = "libimobiledevice";
  version = "2019-04-04";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "eea4f1be9107c8ab621fd71460e47d0d38e55d71";
    sha256 = "0wh6z5f5znlqs0grh7c8jj1s411azgyy45klmql5kj3p8qqybqrs";
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
    "--disable-static"
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
