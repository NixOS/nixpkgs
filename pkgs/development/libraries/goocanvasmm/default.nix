{ lib, stdenv, fetchurl, pkg-config, goocanvas2, gtkmm3, gnome }:

stdenv.mkDerivation rec {
  pname = "goocanvasmm";
  version = "1.90.11";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0vpdfrj59nwzwj8bk4s0h05iyql62pxjzsxh72g3vry07s3i3zw0";
  };
  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ gtkmm3 goocanvas2 ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "goocanvasmm2";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "C++ bindings for GooCanvas";
    homepage = "https://wiki.gnome.org/Projects/GooCanvas";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
