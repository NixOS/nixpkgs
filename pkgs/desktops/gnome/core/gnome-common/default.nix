{ lib, stdenv, fetchurl, which, gnome, autoconf, automake }:

stdenv.mkDerivation rec {
  pname = "gnome-common";
  version = "3.18.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-common/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "22569e370ae755e04527b76328befc4c73b62bfd4a572499fde116b8318af8cf";
  };

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-common"; attrPath = "gnome.gnome-common"; };
  };

  propagatedBuildInputs = [ which autoconf automake ]; # autogen.sh which is using gnome-common tends to require which

  meta = with lib; {
    maintainers = teams.gnome.members;
  };
}
