{ lib, stdenv, fetchurl, atk, glibmm, pkg-config, gnome3 }:

stdenv.mkDerivation rec {
  pname = "atkmm";
  version = "2.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0wwr0663jrqx2klsasffd9wpk3kqnwisj1y3ahdkjdk5hzrsjgy9";
  };

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ atk glibmm ];

  nativeBuildInputs = [ pkg-config ];

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
