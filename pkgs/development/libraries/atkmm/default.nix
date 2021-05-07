{ lib, stdenv, fetchurl, atk, glibmm, pkg-config, gnome }:

stdenv.mkDerivation rec {
  pname = "atkmm";
  version = "2.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0fnxrspxkhhbrjphqrpvl3zjm66n50s4cywrrrwkhbflgy8zqk2c";
  };

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ atk glibmm ];

  nativeBuildInputs = [ pkg-config ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
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
