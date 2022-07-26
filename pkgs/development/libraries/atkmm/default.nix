{ lib, stdenv, fetchurl, atk, glibmm, pkg-config, gnome, meson, ninja, python3 }:

stdenv.mkDerivation rec {
  pname = "atkmm";
  version = "2.28.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-fCCItIapCb6NorGDBOVsX5CITRNDyNpzZ+pc0yWLmWk=";
  };

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ atk glibmm ];

  nativeBuildInputs = [ pkg-config meson python3 ninja ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
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
