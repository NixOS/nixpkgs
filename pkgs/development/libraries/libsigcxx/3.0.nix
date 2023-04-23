{ stdenv
, lib
, fetchurl
, pkg-config
, meson
, ninja
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libsigc++";
  version = "3.4.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "AuJjD/tc6TzVLDhCNSHf5wYzKIY6bpbUHXZaYRa4cH4=";
  };

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

  meta = with lib; {
    homepage = "https://libsigcplusplus.github.io/libsigcplusplus/";
    description = "A typesafe callback system for standard C++";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.all;
  };
}
