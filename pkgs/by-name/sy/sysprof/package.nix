{
  stdenv,
  lib,
  desktop-file-utils,
  fetchurl,
  elfutils,
  gettext,
  glib,
  gtk4,
  json-glib,
  itstool,
  libadwaita,
  libdex,
  libpanel,
  libunwind,
  libxml2,
  meson,
  ninja,
  pkg-config,
  polkit,
  shared-mime-info,
  systemdLibs,
  wrapGAppsHook4,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sysprof";
  version = "51.0";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/sysprof/${lib.versions.major finalAttrs.version}/sysprof-${finalAttrs.version}.tar.xz";
    hash = "sha256-8sjZxcgpTOP9yL59n0vlanLtcVIstUmH8XI6jP2RY30=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    libxml2
    meson
    ninja
    pkg-config
    shared-mime-info
    wrapGAppsHook4
  ];

  buildInputs = [
    elfutils
    glib
    gtk4
    json-glib
    polkit
    systemdLibs
    libadwaita
    libdex
    libpanel
    libunwind
  ];

  strictDeps = true;

  mesonFlags = [
    "-Dsystemdunitdir=lib/systemd/system"
    # In a separate libsysprof-capture package
    "-Dinstall-static=false"
  ]
  # FAILED: [code=1] src/libsysprof/tests/test-flatpak-info
  # ld.bfd: src/libsysprof/tests/test-flatpak-info.p/test-flatpak-info.c.o: R_LARCH_ALIGN with offset 2 not aligned to instruction boundary
  # ld.bfd: BFD (GNU Binutils) 2.46 assertion fail /build/binutils-with-gold-2.46/bfd/elfnn-loongarch.c:4355
  # ld.bfd: src/libsysprof/tests/test-flatpak-info.p/test-flatpak-info.c.o: relocation R_LARCH_CALL36 right shift 2 error 0xffffffffffffeecb
  ++ lib.optionals stdenv.hostPlatform.isLoongArch64 [
    (lib.mesonBool "tests" false)
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "sysprof";
    };
  };

  __structuredAttrs = true;

  meta = {
    description = "System-wide profiler for Linux";
    homepage = "https://gitlab.gnome.org/GNOME/sysprof";
    longDescription = ''
      Sysprof is a sampling CPU profiler for Linux that uses the perf_event_open
      system call to profile the entire system, not just a single
      application.  Sysprof handles shared libraries and applications
      do not need to be recompiled.  In fact they don't even have to
      be restarted.
    '';
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.unix;
  };
})
