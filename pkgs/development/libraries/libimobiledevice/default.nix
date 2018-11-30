{ stdenv, fetchFromGitHub, automake, autoconf, libtool, pkgconfig, gnutls
, libgcrypt, libtasn1, glib, libplist, libusbmuxd }:

stdenv.mkDerivation rec {
  pname = "libimobiledevice";
  version = "2018-07-24";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "d7a2e04d2e7880c56116fd35489a7f98755501b7";
    sha256 = "0cj0j10lmfr28c7nh79n2mcmy31xx50g93h0bqs0l7y76ph4dqkc";
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
    maintainers = with maintainers; [ ];
  };
}
