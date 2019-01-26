{ stdenv, fetchurl, pkgconfig, libxml2, libxslt, gnome3
, gnome-doc-utils, intltool, libX11, which, itstool, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "zenity-${version}";
  version = "3.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/zenity/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1wipnp46pd238z9ck5rsckbaw7yla6c936fswq5w94k4c6bgcplr";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "zenity"; attrPath = "gnome3.zenity"; };
  };

  preBuild = ''
    mkdir -p $out/include
  '';

  buildInputs = [ gnome3.gtk libxml2 libxslt libX11 itstool ];

  nativeBuildInputs = [ pkgconfig intltool gnome-doc-utils which wrapGAppsHook ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
