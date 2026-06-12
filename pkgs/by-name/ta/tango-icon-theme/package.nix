{
  lib,
  stdenv,
  fetchurl,
  intltool,
  pkg-config,
  iconnamingutils,
  imagemagick,
  librsvg,
  gtk3, # any version
  gnome-icon-theme,
  hicolor-icon-theme,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tango-icon-theme";
  version = "0.8.90";

  src = fetchurl {
    url = "https://tango.freedesktop.org/releases/tango-icon-theme-${finalAttrs.version}.tar.gz";
    hash = "sha256-bpjYAy1X2BisyQfsR+anGIUf8lGufCmq+4aHQ+tlyI4=";
  };

  patches = [ ./rsvg-convert.patch ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    intltool
    gtk3
    librsvg
    imagemagick
    iconnamingutils
    gnome-icon-theme
    hicolor-icon-theme
  ];

  propagatedBuildInputs = [
    gnome-icon-theme
    hicolor-icon-theme
  ];
  # still missing parent icon themes: cristalsvg

  strictDeps = true;

  dontDropIconThemeCache = true;

  configureFlags = [ "--enable-png-creation" ];

  postInstall = ''
    gtk-update-icon-cache $out/share/icons/Tango
  '';

  __structuredAttrs = true;

  meta = {
    description = "Basic set of icons";
    homepage = "https://tango.freedesktop.org/Tango_Icon_Library";
    platforms = lib.platforms.linux;
    license = lib.licenses.publicDomain;
    hasNoMaintainersButDependents = true;
  };
})
