{ stdenv, fetchurl, which, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "gnome-common-3.12.0";

  src = fetchurl {
    url = "https://download.gnome.org/sources/gnome-common/3.12/${name}.tar.xz";
    sha256 = "18712bc2df6b2dd88a11b9f7f874096d1c0c6e7ebc9cfc0686ef963bd590e1d8";
  };

  patches = [(fetchurl {
    url = "https://bug697543.bugzilla-attachments.gnome.org/attachment.cgi?id=240935";
    sha256 = "17abp7czfzirjm7qsn2czd03hdv9kbyhk3lkjxg2xsf5fky7z7jl";
  })];

  propagatedBuildInputs = [ which autoconf automake ]; # autogen.sh which is using gnome_common tends to require which
}
