{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  gtk2,
  dbus-glib,
}:

stdenv.mkDerivation rec {
  pname = "libunique";
  version = "1.1.6";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "1fsgvmncd9caw552lyfg8swmsd6bh4ijjsph69bwacwfxwf09j75";
  };

  # Don't make deprecated usages hard errors
  prePatch = ''
    substituteInPlace configure --replace "-Werror" "";
  '';

  # glib-2.62 deprecations
  env.NIX_CFLAGS_COMPILE = "-DGLIB_DISABLE_DEPRECATION_WARNINGS";

  # Patches from Gentoo portage
  patches = [
    ./1.1.6-compiler-warnings.patch
    ./1.1.6-fix-test.patch
    ./1.1.6-G_CONST_RETURN.patch
    ./1.1.6-include-terminator.patch
  ] ++ [ ./gcc7-bug.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    gtk2
    dbus-glib
  ];

  doCheck = true;

  meta = {
    homepage = "https://gitlab.gnome.org/Archive/unique";
    description = "A library for writing single instance applications";
    license = lib.licenses.lgpl21;
    platforms = with lib.platforms; linux ++ darwin;
  };
}
