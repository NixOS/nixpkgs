{ stdenv
, fetchurl
, fetchpatch
, pkgconfig
, mono
, glib
, pango
, gtk3
, GConf ? null
, libglade ? null
, libgtkhtml ? null
, gtkhtml ? null
, libgnomecanvas ? null
, libgnomeui ? null
, libgnomeprint ? null
, libgnomeprintui ? null
, libxml2
, monoDLLFixer
}:

stdenv.mkDerivation rec {
  pname = "gtk-sharp";
  version = "2.99.3";

  builder = ./builder.sh;
  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "18n3l9zcldyvn4lwi8izd62307mkhz873039nl6awrv285qzah34";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    mono glib pango gtk3 GConf libglade libgnomecanvas
    libgtkhtml libgnomeui libgnomeprint libgnomeprintui gtkhtml libxml2
  ];

  patches = [
    # Fixes MONO_PROFILE_ENTER_LEAVE undeclared when compiling against newer versions of mono.
    # @see https://github.com/mono/gtk-sharp/pull/266
    (fetchpatch {
      name = "MONO_PROFILE_ENTER_LEAVE.patch";
      url = "https://github.com/mono/gtk-sharp/commit/401df51bc461de93c1a78b6a7a0d5adc63cf186c.patch";
      sha256 = "0hrkcr5a7wkixnyp60v4d6j3arsb63h54rd30lc5ajfjb3p92kcf";
    })
  ];

  dontStrip = true;

  inherit monoDLLFixer;

  passthru = {
    inherit gtk3;
  };

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
