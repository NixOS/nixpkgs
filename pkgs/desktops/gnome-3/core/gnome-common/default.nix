{ stdenv, fetchurl, which, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "gnome-common-3.10.0";

  src = fetchurl {
    url = "https://download.gnome.org/sources/gnome-common/3.10/${name}.tar.xz";
    sha256 = "aed69474a671e046523827f73ba5e936d57235b661db97900db7356e1e03b0a3";
  };

  patches = [(fetchurl {
    url = "https://bug697543.bugzilla-attachments.gnome.org/attachment.cgi?id=240935";
    sha256 = "17abp7czfzirjm7qsn2czd03hdv9kbyhk3lkjxg2xsf5fky7z7jl";
  })];

  propagatedBuildInputs = [ which autoconf automake ]; # autogen.sh which is using gnome_common tends to require which
}
