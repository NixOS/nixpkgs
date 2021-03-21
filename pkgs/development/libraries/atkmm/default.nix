{ lib, stdenv, fetchurl, atk, glibmm, pkg-config, meson, ninja, python3, gnome3 }:

stdenv.mkDerivation rec {
  pname = "atkmm";
  version = "2.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-EWh2YEdwZBpFDjnB9QMCiEhIzpzEjUPF3I6O/DHzG60=";
  };

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ atk glibmm ];

  nativeBuildInputs = [ pkg-config meson ninja python3 ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
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
