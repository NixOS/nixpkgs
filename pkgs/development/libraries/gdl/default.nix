{ lib, stdenv, fetchurl, fetchpatch, pkg-config, libxml2, gtk3, gnome, intltool }:

stdenv.mkDerivation rec {
  pname = "gdl";
  version = "3.40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gdl/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "NkHU/WadHhgYrv88+f+3iH/Fw2eFC3jCjHdeukq2pVU=";
  };

  patches = [
    # Fix build with libxml 2.12
    # https://gitlab.gnome.org/GNOME/gdl/-/merge_requests/4
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gdl/-/commit/414f83eb4ad9e5576ee3d089594bf1301ff24091.patch";
      hash = "sha256-Uy+WlTCxkq45Al8XqW8/gGl/PiVc7AOik1phmMBj4Vo=";
    })
  ];

  nativeBuildInputs = [ pkg-config intltool ];
  buildInputs = [ libxml2 gtk3 ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gdl";
    };
  };

  meta = with lib; {
    description = "Gnome docking library";
    homepage = "https://developer.gnome.org/gdl/";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
