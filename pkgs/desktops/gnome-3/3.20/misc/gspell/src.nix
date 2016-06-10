fetchurl: rec {
  major = "1.0";
  minor = "0";
  name = "gspell-${major}.${minor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gspell/${major}/${name}.tar.xz";
    sha256 = "1nkpy005qyrfdklrjnvx5xksd3dv27fmn48wi12q8c8whxy2al3a";
  };
}
