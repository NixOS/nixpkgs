{
  lib,
  stdenv,
  fetchFromGitHub,
  acl,
  glib,
  intltool,
  pkg-config,
  udev,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "udevil";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "IgnorantGuru";
    repo = "udevil";
    tag = finalAttrs.version;
    hash = "sha256-TTW2gPa4ND6ILq4yxKEL07AQpSqfiEo66S72lVEmpFk=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];

  buildInputs = [
    glib
    udev
  ];

  preConfigure = ''
    substituteInPlace src/Makefile.in --replace "-o root -g root" ""
    # do not set setuid bit in nix store
    substituteInPlace src/Makefile.in --replace 4755 0755
  '';

  configureFlags = [
    "--with-mount-prog=${util-linux}/bin/mount"
    "--with-umount-prog=${util-linux}/bin/umount"
    "--with-losetup-prog=${util-linux}/bin/losetup"
    "--with-setfacl-prog=${acl.bin}/bin/setfacl"
    "--sysconfdir=${placeholder "out"}/etc"
  ];

  postInstall = ''
    substituteInPlace $out/lib/systemd/system/devmon@.service \
      --replace /usr/bin/devmon "$out/bin/devmon"
  '';

  patches = [
    # sys/stat.h header missing on src/device-info.h
    ./device-info-sys-stat.patch

    ./fix-gcc15.patch
  ];

  meta = {
    homepage = "https://ignorantguru.github.io/udevil/";
    description = "Mount without password";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
