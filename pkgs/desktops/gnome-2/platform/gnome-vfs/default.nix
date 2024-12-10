{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  libxml2,
  bzip2,
  openssl,
  dbus-glib,
  glib,
  gamin,
  cdparanoia,
  intltool,
  GConf,
  gnome_mime_data,
  avahi,
  acl,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-vfs";
  version = "2.24.4";

  src =
    let
      inherit (finalAttrs) pname version;
    in
    fetchurl {
      url = "mirror://gnome/sources/gnome-vfs/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
      sha256 = "1ajg8jb8k3snxc7rrgczlh8daxkjidmcv3zr9w809sq4p2sn9pk2";
    };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    intltool
    pkg-config
  ];
  buildInputs = [
    libxml2
    bzip2
    openssl
    dbus-glib
    gamin
    cdparanoia
    gnome_mime_data
    avahi
    acl
  ];

  propagatedBuildInputs = [
    GConf
    glib
  ];

  # struct SSL is opaque in openssl-1.1; and the SSL_free() man page
  # says that one should not free members of it manually (in both
  # the openssl-1.0 and openssl-1.1 man pages).
  # https://bugs.gentoo.org/592540
  patches = [
    (fetchpatch {
      name = "gnome-vfs-2.24.4-openssl-1.1.patch";
      url = "https://bugs.gentoo.org/attachment.cgi?id=535944";
      sha256 = "1q4icapvmwmd5rjah7rr0bqazzk5cg36znmjlpra20n9y27nz040";
      extraPrefix = "";
    })
  ];

  postPatch = "find . -name Makefile.in | xargs sed 's/-DG_DISABLE_DEPRECATED//g' -i ";

  doCheck = false; # needs dbus daemon

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    pkgConfigModules = [
      "gnome-vfs-2.0"
      "gnome-vfs-module-2.0"
    ];
  };
})
