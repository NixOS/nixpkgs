{ lib, stdenv, fetchurl, flex, bison, pkg-config, glib, gettext }:

stdenv.mkDerivation rec {
  pname = "libIDL";
  version = "0.8.14";

  src = fetchurl {
    url = "mirror://gnome/sources/libIDL/${lib.versions.majorMinor version}/libIDL-${version}.tar.bz2";
    sha256 = "08129my8s9fbrk0vqvnmx6ph4nid744g5vbwphzkaik51664vln5";
  };

  strictDeps = true;

  buildInputs = [ glib gettext ];

  nativeBuildInputs = [ flex bison pkg-config ];

  configureFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    # before openembedded removed libIDL
    # the result was always ll https://lists.openembedded.org/g/openembedded-core/topic/85775262?p=%2C%2C%2C20%2C0%2C0%2C0%3A%3A%2C%2C%2C0%2C0%2C0%2C85775262
    "libIDL_cv_long_long_format=ll"
  ];
  meta.mainProgram = "libIDL-config-2";
}
