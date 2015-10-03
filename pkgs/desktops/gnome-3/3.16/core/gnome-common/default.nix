{ stdenv, fetchurl, which, gnome3, autoconf, automake }:

let
  majVer = "3.14";
in stdenv.mkDerivation rec {
  name = "gnome-common-${majVer}.0";

  src = fetchurl {
    url = "https://download.gnome.org/sources/gnome-common/${majVer}/${name}.tar.xz";
    sha256 = "0b1676g4q44ah73c5gwl1kg88pc93pnq1pa9kwl43d0vg0pj802c";
  };

  patches = [(fetchurl {
    url = "https://bug697543.bugzilla-attachments.gnome.org/attachment.cgi?id=240935";
    sha256 = "17abp7czfzirjm7qsn2czd03hdv9kbyhk3lkjxg2xsf5fky7z7jl";
  })];

  propagatedBuildInputs = [ which autoconf automake ]; # autogen.sh which is using gnome_common tends to require which

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
  };
}
