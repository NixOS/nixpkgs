{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  caja,
  glib,
  gst_all_1,
  gtk3,
  gupnp,
  imagemagick,
  mate-desktop,
  wrapGAppsHook3,
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "caja-extensions";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0phsXgdAg1/icc+9WCPu6vAyka8XYyA/RwCruBCeMXU=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    caja
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gtk3
    gupnp
    imagemagick
    mate-desktop
  ];

  postPatch = ''
    for f in image-converter/caja-image-{resizer,rotator}.c; do
      substituteInPlace $f --replace-fail 'argv[0] = "convert"' 'argv[0] = "${imagemagick}/bin/convert"'
    done
  '';

  configureFlags = [ "--with-cajadir=$$out/lib/caja/extensions-2.0" ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Set of extensions for Caja file manager";
    mainProgram = "caja-sendto";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
