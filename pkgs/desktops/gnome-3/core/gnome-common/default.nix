{ stdenv, fetchurl, which }:

stdenv.mkDerivation rec {
  name = "gnome-common-3.10.0";

  src = fetchurl {
    url = "https://download.gnome.org/sources/gnome-common/3.10/${name}.tar.xz";
    sha256 = "aed69474a671e046523827f73ba5e936d57235b661db97900db7356e1e03b0a3";
  };

  propagatedBuildInputs = [ which ]; # autogen.sh which is using gnome_common tends to require which
}
