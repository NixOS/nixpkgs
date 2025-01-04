{
  lib,
  stdenv,
  fetchurl,
  atk,
  glibmm_2_68,
  pkg-config,
  gnome,
  meson,
  ninja,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "atkmm";
  version = "2.36.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-bsJk6qDE3grbcgLGABcL3pp/vk1Ga/vpQOr3+qpsWXQ=";
  };

  outputs = [
    "out"
    "dev"
  ];

  propagatedBuildInputs = [
    atk
    glibmm_2_68
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    python3
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "atkmm_2_36";
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "C++ wrappers for ATK accessibility toolkit";
    license = lib.licenses.lgpl21Plus;
    homepage = "https://gtkmm.org";
    platforms = lib.platforms.unix;
  };
}
