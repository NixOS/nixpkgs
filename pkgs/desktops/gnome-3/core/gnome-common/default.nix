{ stdenv, fetchurl, which, gnome3, autoconf, automake }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  patches = [(fetchurl {
    name = "gnome-common-patch";
    url = "https://bug697543.bugzilla-attachments.gnome.org/attachment.cgi?id=240935";
    sha256 = "17abp7czfzirjm7qsn2czd03hdv9kbyhk3lkjxg2xsf5fky7z7jl";
  })];

  propagatedBuildInputs = [ which autoconf automake ]; # autogen.sh which is using gnome_common tends to require which

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
  };
}
