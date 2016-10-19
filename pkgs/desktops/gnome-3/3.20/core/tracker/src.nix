fetchurl: rec {
  major = "1.10";
  minor = "1";
  name = "tracker-${major}.${minor}";

  src = fetchurl {
    url = "mirror://gnome/sources/tracker/${major}/${name}.tar.xz";
    sha256 = "14a13wbsx2ragscdwb47df4cr0sn42sl1pfwvlrndggbm367isk7";
  };

}
