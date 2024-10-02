{ stdenv
, lib
, fetchurl
, fetchpatch
, meson
, ninja
, gettext
, gst_all_1
, python3Packages
, shared-mime-info
, pkg-config
, gtk3
, glib
, gobject-introspection
, totem-pl-parser
, wrapGAppsHook3
, itstool
, libxml2
, vala
, gnome
, grilo
, grilo-plugins
, libpeas
, libportal-gtk3
, libhandy
, adwaita-icon-theme
, gnome-desktop
, gsettings-desktop-schemas
, gdk-pixbuf
, xvfb-run
}:

stdenv.mkDerivation rec {
  pname = "totem";
  version = "43.0";

  src = fetchurl {
    url = "mirror://gnome/sources/totem/${lib.versions.major version}/totem-${version}.tar.xz";
    hash = "sha256-s202VZKLWJZGKk05+Dtq1m0328nJnc6wLqii43OUpB4=";
  };

  patches = [
    # Lower X11 dependency version since we do not have it.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/totem/-/commit/140d9eea70c3101ef3234abb4de5974cb84b13db.patch";
      hash = "sha256-ohppxqMiH8Ksc9B2e3AXighfM6KVN+RNXYL+fLELSN8=";
      revert = true;
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/totem/-/commit/2610b4536f73493587e4a5a38e01c9961fcabb96.patch";
      hash = "sha256-nPfzS+LQuAlyQOz67hCdtx93w2frhgWlg1KGX5bEU38=";
      revert = true;
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/totem/-/commit/5b871aee5292f25bbf39dca18045732e979e7a68.patch";
      hash = "sha256-LqQLdgyZkIVc+/hQ5sdBLqhtjCVIMDSs9tjVXwMFodg=";
      revert = true;
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

  # Tests do not work with GStreamer 1.18.
  # https://gitlab.gnome.org/GNOME/totem/-/issues/450
  doCheck = false;

  postPatch = ''
    chmod +x meson_compile_python.py # patchShebangs requires executable file
    patchShebangs \
      ./meson_compile_python.py
  '';

  checkPhase = ''
    runHook preCheck

    xvfb-run -s '-screen 0 800x600x24' \
      ninja test

    runHook postCheck
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "totem";
    };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/Totem/";
    description = "Movie player for the GNOME desktop based on GStreamer";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus; # with exception to allow use of non-GPL compatible plug-ins
    platforms = platforms.linux;
  };
}
