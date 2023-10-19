{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, gtk3
, gupnp
, mate
, imagemagick
, wrapGAppsHook
, mateUpdateScript
, glib
, substituteAll
}:

stdenv.mkDerivation rec {
  pname = "caja-extensions";
  version = "1.26.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "WJwZ4/oQJC1iOaXMuVhVmENqVuvpTS6ypQtZUMzh1SA=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gupnp
    mate.caja
    mate.mate-desktop
    imagemagick
  ];

  patches = [
    (substituteAll {
      src = ./hardcode-gsettings.patch;
      caja_gsetttings_path = glib.getSchemaPath mate.caja;
      desktop_gsetttings_path = glib.getSchemaPath mate.mate-desktop;
    })
  ];

  postPatch = ''
    substituteInPlace open-terminal/caja-open-terminal.c --subst-var-by \
      GSETTINGS_PATH ${glib.makeSchemaPath "$out" "${pname}-${version}"}
    substituteInPlace sendto/caja-sendto-command.c --subst-var-by \
      GSETTINGS_PATH ${glib.makeSchemaPath "$out" "${pname}-${version}"}
    substituteInPlace wallpaper/caja-wallpaper-extension.c --subst-var-by \
      GSETTINGS_PATH ${glib.makeSchemaPath "$out" "${pname}-${version}"}

    for f in image-converter/caja-image-{resizer,rotator}.c; do
      substituteInPlace $f --replace "/usr/bin/convert" "${imagemagick}/bin/convert"
    done
  '';

  configureFlags = [ "--with-cajadir=$$out/lib/caja/extensions-2.0" ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Set of extensions for Caja file manager";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
