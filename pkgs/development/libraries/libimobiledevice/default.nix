{ stdenv, fetchurl, python, swig, pkgconfig, usbmuxd, glib, gnutls, libgcrypt,
  libtasn1, libplist, readline }:

stdenv.mkDerivation rec {
  name = "libimobiledevice-1.0.2";

  buildInputs = [ python swig pkgconfig readline ];
  propagatedBuildInputs = [ usbmuxd glib gnutls libgcrypt libtasn1 libplist ];

  configureFlags = "--enable-dev-tools";

  src = fetchurl {
    url = "${meta.homepage}/downloads/${name}.tar.bz2";
    sha256 = "1wbx0hr0q1dhw1p7326qm3dvzacykhc4w005q5wp2gkxa68dnw5s";
  };

  meta = {
    homepage = http://www.libimobiledevice.org;
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
      devices to the Linux Desktop.'';
    inherit (usbmuxd.meta) platforms maintainers;
  };
}
