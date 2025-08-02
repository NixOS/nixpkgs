{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "libsigc++";
  version = "2.12.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-qdvuMjNR0Qm3ruB0qcuJyj57z4rY7e8YUfTPNZvVCEM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "libsigcxx";
      versionPolicy = "odd-unstable";
      freeze = "2.99.1";
    };
  };

  meta = {
    homepage = "https://libsigcplusplus.github.io/libsigcplusplus/";
    description = "Typesafe callback system for standard C++";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
  };
}
