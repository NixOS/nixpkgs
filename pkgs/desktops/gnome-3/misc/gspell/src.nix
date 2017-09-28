fetchurl: rec {
  major = "1.4";
  minor = "1";
  name = "gspell-${major}.${minor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gspell/${major}/${name}.tar.xz";
    sha256 = "1ghh1xdzf04mfgb13zqpj88krpa44xv2vbyhm6k017kzrpz8hbs4";
  };
}
