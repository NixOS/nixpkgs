{ stdenv, fetchurl, pkgconfig, eina, eet, ecore }:
stdenv.mkDerivation rec {
  name = "efreet-${version}";
  version = "1.2.0-alpha";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.bz2";
    sha256 = "1nydy3ahdq7q6b0xxaj79a8kd4b4xy3hzf1fdh117c9pwp4fxhl0";
  };
  buildInputs = [ pkgconfig eina eet ecore ];
  meta = {
    description = "Enlightenment's standards handling for freedesktop.org standards";
    longDescription = ''
      Enlightenment's Efreet is a library designed to help apps work
      several of the Freedesktop.org standards regarding Icons,
      Desktop files and Menus. To that end it implements the following
      specifications:

        * XDG Base Directory Specification
        * Icon Theme Specification
        * Desktop Entry Specification
        * Desktop Menu Specification
        * FDO URI Specification
        * Shared Mime Info Specification
        * Trash Specification 
    '';
    homepage = http://enlightenment.org/;
    license = stdenv.lib.licenses.bsd2;  # not sure
  };
}
