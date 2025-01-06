{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "libsigc++";
  version = "3.6.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "w9I7N9/W458uCfCRt3sVQfv6F8Twtr9cibrvcikIDhc=";
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
      attrPath = "libsigcxx30";
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    homepage = "https://libsigcplusplus.github.io/libsigcplusplus/";
    description = "Typesafe callback system for standard C++";
    license = lib.licenses.lgpl21Plus;
    maintainers = lib.teams.gnome.members;
    platforms = lib.platforms.all;
  };
}
