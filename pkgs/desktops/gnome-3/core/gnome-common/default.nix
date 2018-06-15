{ stdenv, fetchurl, which, gnome3, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "gnome-common-${version}";
  version = "3.18.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-common/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "22569e370ae755e04527b76328befc4c73b62bfd4a572499fde116b8318af8cf";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-common"; attrPath = "gnome3.gnome-common"; };
  };

  patches = [(fetchurl {
    name = "gnome-common-patch";
    url = "https://bug697543.bugzilla-attachments.gnome.org/attachment.cgi?id=240935";
    sha256 = "17abp7czfzirjm7qsn2czd03hdv9kbyhk3lkjxg2xsf5fky7z7jl";
  })];

  propagatedBuildInputs = [ which autoconf automake ]; # autogen.sh which is using gnome-common tends to require which

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
  };
}
