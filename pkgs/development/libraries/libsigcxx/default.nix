{ lib, stdenv, fetchurl, pkg-config, meson, ninja, gnome }:

stdenv.mkDerivation rec {
  pname = "libsigc++";
  version = "2.10.7";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-0IKiznLHUPZrGkFavj6FLfLq4eivUwEPSsLqJhpHiDI=";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "libsigcxx";
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = with lib; {
    homepage = "https://libsigcplusplus.github.io/libsigcplusplus/";
    description = "A typesafe callback system for standard C++";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };
}
