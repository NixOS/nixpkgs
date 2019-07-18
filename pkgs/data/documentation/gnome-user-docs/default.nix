{ stdenv, fetchurl, itstool, libxml2, gettext, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-user-docs";
  version = "3.2.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1ka0nw2kc85p10y8x31v0wv06a88k7qrgafp4ys04y9fzz0rkcjj";
  };

  nativeBuildInputs = [ itstool libxml2 gettext ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.gnome-user-docs";
    };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-user-docs";
    description = "GNOME User Documentation";
    license = stdenv.lib.licenses.cc-by-30;
    maintainers = gnome3.maintainers;
  };
}
