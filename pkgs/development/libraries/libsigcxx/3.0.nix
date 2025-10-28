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
    url = "mirror://gnome/sources/libsigc++/${lib.versions.majorMinor version}/libsigc++-${version}.tar.xz";
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
      packageName = "libsigc++";
      attrPath = "libsigcxx30";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://libsigcplusplus.github.io/libsigcplusplus/";
    description = "Typesafe callback system for standard C++";
    license = licenses.lgpl21Plus;
    teams = [ teams.gnome ];
    platforms = platforms.all;
  };
}
