{ stdenv, fetchurl, which, gnome3, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "gnome-common-${gnome3.version}.0";

  src = fetchurl {
    url = "https://download.gnome.org/sources/gnome-common/${gnome3.version}/${name}.tar.xz";
    sha256 = "4c00242f781bb441289f49dd80ed1d895d84de0c94bfc2c6818a104c9e39262c";
  };

  patches = [(fetchurl {
    url = "https://bug697543.bugzilla-attachments.gnome.org/attachment.cgi?id=240935";
    sha256 = "17abp7czfzirjm7qsn2czd03hdv9kbyhk3lkjxg2xsf5fky7z7jl";
  })];

  propagatedBuildInputs = [ which autoconf automake ]; # autogen.sh which is using gnome_common tends to require which

  meta = with stdenv.lib; {
    maintainers = [ maintainers.lethalman ];
  };
}
