{ lib
, stdenv
, fetchurl
, pkg-config
, libGLU
, libGL
, libX11
, libXext
, libXfixes
, libXdamage
, libXcomposite
, libXi
, libxcb
, cogl
, pango
, atk
, json-glib
, gobject-introspection
, gtk3
, gnome
, libinput
, libgudev
, libxkbcommon
}:

stdenv.mkDerivation rec {
  pname = "clutter";
  version = "1.26.4";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1rn4cd1an6a9dfda884aqpcwcgq8dgydpqvb19nmagw4b70zlj4b";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [
    gtk3
  ];
  nativeBuildInputs = [
    pkg-config
  ];
  propagatedBuildInputs = [
    libX11
    libGL
    libGLU
    libXext
    libXfixes
    libXdamage
    libXcomposite
    libXi
    cogl
    pango
    atk
    json-glib
    gobject-introspection
    libxcb
    libinput
    libgudev
    libxkbcommon
  ];

  configureFlags = [
    "--enable-introspection" # needed by muffin AFAIK
    "--enable-wayland-compositor"
  ];

  #doCheck = true; # no tests possible without a display

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "Library for creating fast, dynamic graphical user interfaces";
    license = lib.licenses.lgpl2Plus;
    homepage = "http://www.clutter-project.org/";
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = lib.platforms.mesaPlatforms;
  };
}
