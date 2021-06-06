{ lib, stdenv, fetchurl, pkg-config, meson, ninja, gnome }:

stdenv.mkDerivation rec {
  pname = "libsigc++";
  version = "2.10.6";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-3aF23EaBvanVoqwbxVJzvdOBZit6bUnpGCZ9E+h3Ths=";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "libsigcxx";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://libsigcplusplus.github.io/libsigcplusplus/";
    description = "A typesafe callback system for standard C++";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };
}
