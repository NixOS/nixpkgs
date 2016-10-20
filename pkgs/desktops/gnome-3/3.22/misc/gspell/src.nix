fetchurl: rec {
  major = "1.0";
  minor = "3";
  name = "gspell-${major}.${minor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gspell/${major}/${name}.tar.xz";
    sha256 = "1m8v4rqaxjsblccc3nnirkbkzgqm90vfpzp3x08lkqriqvk0anfr";
  };
}
