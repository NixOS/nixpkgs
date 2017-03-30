fetchurl: rec {
  major = "1.2";
  minor = "1";
  name = "gspell-${major}.${minor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gspell/${major}/${name}.tar.xz";
    sha256 = "18zisdrq14my2iq6iv3lhqfn9jg98bqwbzcdidp7hfk915gkw74z";
  };
}
