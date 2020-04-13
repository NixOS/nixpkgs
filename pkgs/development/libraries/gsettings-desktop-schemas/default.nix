{ stdenv, fetchurl, pkgconfig, glib, gobject-introspection
, meson
, ninja
, python3
  # just for passthru
, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gsettings-desktop-schemas";
  version = "3.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gsettings-desktop-schemas/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "19hfjqzddkmvxg80v23xpbd1my2pzjalx3d56d2k4dk5521vcjkn";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gsettings-desktop-schemas"; };
  };

  # meson installs the schemas to share/glib-2.0/schemas
  # We add the override file there too so it will be compiled and later moved by
  # glib's setup hook.
  preInstall = ''
    mkdir -p $out/share/glib-2.0/schemas
    cat - > $out/share/glib-2.0/schemas/remove-backgrounds.gschema.override <<- EOF
      [org.gnome.desktop.background]
      picture-uri='''

      [org.gnome.desktop.screensaver]
      picture-uri='''
    EOF
  '';

  postPatch = ''
    chmod +x build-aux/meson/post-install.py
    patchShebangs build-aux/meson/post-install.py
  '';

  buildInputs = [ glib gobject-introspection ];

  nativeBuildInputs = [ pkgconfig python3 meson ninja glib ];

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
  };
}
