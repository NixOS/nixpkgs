{ stdenv, fetchurl, intltool, pkgconfig, gtk3, vala_0_32, libgee, wrapGAppsHook, itstool, gobjectIntrospection
, gnome-online-accounts, evolution-data-server, gnome3, glib, libsoup, libgdata, sqlite, xdg_utils }:

let
  pname = "california";
  version = "0.4.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1dky2kllv469k8966ilnf4xrr7z35pq8mdvs7kwziy59cdikapxj";
  };

  nativeBuildInputs = [ intltool itstool vala_0_32 pkgconfig wrapGAppsHook gobjectIntrospection ];
  buildInputs = [ glib gtk3 libgee libsoup libgdata gnome-online-accounts evolution-data-server sqlite xdg_utils gnome3.gsettings-desktop-schemas ];

  enableParallelBuilding = true;

  patches = [
    # Apply Fedora patch to build with evolution-data-server > 3.13
    (fetchurl {
      url = https://src.fedoraproject.org/rpms/california/raw/c00bf9924d8fa8cb0a9ec06564d1a1b00c9055af/f/0002-Build-with-evolution-data-server-3.13.90.patch;
      sha256 = "0g9923n329p32gzr1q52ad30f8vyz8vrri4rih0w8klmf02ga4pm";
    })
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/California;
    description = "Calendar application for GNOME 3";
    maintainers = with maintainers; [ pSub ];
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
