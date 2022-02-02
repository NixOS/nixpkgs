{ lib, stdenv
, fetchurl
, fetchpatch
, pkg-config
, mono
, glib
, pango
, gtk3
, libxml2
, monoDLLFixer
}:

stdenv.mkDerivation rec {
  pname = "gtk-sharp";
  version = "2.99.3";

  builder = ./builder.sh;
  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "18n3l9zcldyvn4lwi8izd62307mkhz873039nl6awrv285qzah34";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    mono glib pango gtk3
    libxml2
  ];

  patches = [
    # Fixes MONO_PROFILE_ENTER_LEAVE undeclared when compiling against newer versions of mono.
    # @see https://github.com/mono/gtk-sharp/pull/266
    (fetchpatch {
      name = "MONO_PROFILE_ENTER_LEAVE.patch";
      url = "https://github.com/mono/gtk-sharp/commit/401df51bc461de93c1a78b6a7a0d5adc63cf186c.patch";
      sha256 = "0hrkcr5a7wkixnyp60v4d6j3arsb63h54rd30lc5ajfjb3p92kcf";
    })
    # @see https://github.com/mono/gtk-sharp/pull/263
    (fetchpatch {
      name = "disambiguate_Gtk.Range.patch";
      url = "https://github.com/mono/gtk-sharp/commit/a00552ad68ae349e89e440dca21b86dbd6bccd30.patch";
      sha256 = "1ylplr9g9x7ybsgrydsgr6p3g7w6i46yng1hnl3afgn4vj45rag2";
    })
  ];

  dontStrip = true;

  inherit monoDLLFixer;

  passthru = {
    inherit gtk3;
  };

  meta = {
    platforms = lib.platforms.linux;
  };
}
