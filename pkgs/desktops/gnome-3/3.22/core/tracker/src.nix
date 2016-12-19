fetchurl: rec {
  major = "1.10";
  minor = "0";
  name = "tracker-${major}.${minor}";

  src = fetchurl {
    url = "mirror://gnome/sources/tracker/${major}/${name}.tar.xz";
    sha256 = "df95b4a1e7de442f66d1097b725dd3cdd739862f491453fc7d7b1f88181a12fb";
  };

}
