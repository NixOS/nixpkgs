{ stdenv, fetchurl, pkgconfig, glibmm, libgda, libxml2, gnome3
, mysqlSupport ? false, mysql ? null
, postgresSupport ? false, postgresql ? null }:

let
  gda = libgda.override {
    inherit mysqlSupport postgresSupport;
  };
in stdenv.mkDerivation rec {
  pname = "libgdamm";
  version = "4.99.11";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1fyh15b3f8hmwbswalxk1g4l04yvvybksn5nm7gznn5jl5q010p9";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glibmm libxml2 ];
  propagatedBuildInputs = [ gda ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "C++ bindings for libgda";
    homepage = http://www.gnome-db.org/;
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
