{
  lib,
  stdenv,
  fetchurl,
  atk,
  glibmm,
  pkg-config,
  gnome,
  meson,
  ninja,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "atkmm";
  version = "2.28.4";

  src = fetchurl {
    url = "mirror://gnome/sources/atkmm/${lib.versions.majorMinor version}/atkmm-${version}.tar.xz";
    sha256 = "sha256-ChQqgSj4PAAe+4AU7kY+mnZgVO+EaGr5UxNeBNKP2rM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  propagatedBuildInputs = [
    atk
    glibmm
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    python3
    ninja
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "atkmm";
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = {
    description = "C++ wrappers for ATK accessibility toolkit";
    license = lib.licenses.lgpl21Plus;
    homepage = "https://gtkmm.org";
    platforms = lib.platforms.unix;
  };
}
