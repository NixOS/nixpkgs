{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
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
  libepoxy,
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
  version = "43.2";

  src = fetchurl {
    url = "mirror://gnome/sources/totem/${lib.versions.major version}/totem-${version}.tar.xz";
    hash = "sha256-CwB9MPu5O5WmBPFISKSX9X/DM6dcLmOKJJly6ZwB5qQ=";
  };

  patches = [
    # Use girepository-2.0
    # This will be ported to libpeas2 in https://gitlab.gnome.org/GNOME/totem/-/merge_requests/373
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/totem/raw/a213a514b7c2ac22d4e012e168e41eaf839e8112/f/girepository-2.0.patch";
      hash = "sha256-D+i45yebZMbA7Ybfog3bwtOghoIHHVMqyXiUcZTkpxk=";
    })
  ];

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
    gst_all_1.gstreamer # gst-inspect-1.0
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
    libepoxy
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

  meta = {
    homepage = "https://apps.gnome.org/Totem/";
    changelog = "https://gitlab.gnome.org/GNOME/totem/-/blob/${version}/NEWS?ref_type=tags";
    description = "Movie player for the GNOME desktop based on GStreamer";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl2Plus; # with exception to allow use of non-GPL compatible plug-ins
    platforms = lib.platforms.linux;
    # gst-inspect-1.0 is not smart enough for cross compiling
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
}
