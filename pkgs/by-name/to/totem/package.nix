{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  gettext,
  gst_all_1,
  python3Packages,
  shared-mime-info,
  pkg-config,
  gtk3,
  glib,
  gobject-introspection,
  totem-pl-parser,
  wrapGAppsHook3,
  itstool,
  libxml2,
  vala,
  gnome,
  grilo,
  grilo-plugins,
  libpeas,
  libportal-gtk3,
  libhandy,
  adwaita-icon-theme,
  gnome-desktop,
  gsettings-desktop-schemas,
  gdk-pixbuf,
  xvfb-run,
}:

stdenv.mkDerivation rec {
  pname = "totem";
  version = "43.1";

  src = fetchurl {
    url = "mirror://gnome/sources/totem/${lib.versions.major version}/totem-${version}.tar.xz";
    hash = "sha256-VmgpHpxkRJhcs//k6k8CEvVMK75g3QERTBqVD5R1nm0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    gettext
    python3Packages.python
    itstool
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    glib
    grilo
    totem-pl-parser
    grilo-plugins
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    libpeas
    libportal-gtk3
    libhandy
    shared-mime-info
    gdk-pixbuf
    libxml2
    adwaita-icon-theme
    gnome-desktop
    gsettings-desktop-schemas
    python3Packages.pygobject3
  ];

  nativeCheckInputs = [
    xvfb-run
  ];

  mesonFlags = [
    # TODO: https://github.com/NixOS/nixpkgs/issues/36468
    "-Dc_args=-I${glib.dev}/include/gio-unix-2.0"
  ];

  doCheck = true;

  postPatch = ''
    chmod +x meson_compile_python.py # patchShebangs requires executable file
    patchShebangs \
      ./meson_compile_python.py
  '';

  checkPhase = ''
    runHook preCheck

    xvfb-run -s '-screen 0 800x600x24' \
      meson test --print-errorlogs

    runHook postCheck
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "totem";
    };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/Totem/";
    changelog = "https://gitlab.gnome.org/GNOME/totem/-/blob/${version}/NEWS?ref_type=tags";
    description = "Movie player for the GNOME desktop based on GStreamer";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus; # with exception to allow use of non-GPL compatible plug-ins
    platforms = platforms.linux;
  };
}
