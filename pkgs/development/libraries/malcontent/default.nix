{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  wrapGAppsNoGuiHook,
  glib,
  coreutils,
  accountsservice,
  dbus,
  pam,
  polkit,
  glib-testing,
  python3,
  nixosTests,
  malcontent-ui,
  gi-docgen,
  libgsystemservice,
  tinycdb,
  libsoup_3,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "malcontent";
  version = "0.14.0";

  outputs = [
    "bin"
    "out"
    "lib"
    "pam"
    "dev"
    "man"
    "installedTests"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pwithnall";
    repo = "malcontent";
    rev = version;
    hash = "sha256-r0tNWP2zbCyDH3G6OBiGc81CnUcwtXIlwbHPxNwqDRQ=";
    fetchSubmodules = true;
  };

  patches = [
    # Allow installing installed tests to a separate output.
    ./installed-tests-path.patch

    # Do not build things that are part of malcontent-ui package
    ./better-separation.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsNoGuiHook
    gi-docgen
  ];

  buildInputs = [
    accountsservice
    dbus
    pam
    polkit
    glib-testing
    libgsystemservice
    libsoup_3
    systemd
    (python3.withPackages (
      pp: with pp; [
        pygobject3
      ]
    ))
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dinstalled_tests=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
    "-Dpamlibdir=${placeholder "pam"}/lib/security"
    "-Dui=disabled"
  ];

  postPatch = ''
    substituteInPlace libmalcontent/tests/app-filter.c \
      --replace-fail "/usr/bin/true" "${coreutils}/bin/true" \
      --replace-fail "/bin/true" "${coreutils}/bin/true" \
      --replace-fail "/usr/bin/false" "${coreutils}/bin/false" \
      --replace-fail "/bin/false" "${coreutils}/bin/false"

    tar -xzf ${tinycdb.src} -C subprojects
    cp -r subprojects/packagefiles/tinycdb/* subprojects/tinycdb-0.81/

    substituteInPlace malcontent-timerd/meson.build \
      malcontent-timer-extension-agent/meson.build \
      malcontent-webd/meson.build \
      --replace-fail "dependency('systemd').get_variable(pkgconfig: 'sysusersdir')" "'${placeholder "out"}/lib/sysusers.d'"

    substituteInPlace malcontent-timerd/meson.build \
      malcontent-timer-extension-agent/meson.build \
      malcontent-webd/meson.build \
      malcontent-webd-update/meson.build \
      --replace-fail "dependency('systemd').get_variable(pkgconfig: 'systemdsystemunitdir')" "'${placeholder "out"}/lib/systemd/system'"
  '';

  postInstall = ''
    # `giDiscoverSelf` only picks up paths in `out` output.
    # This needs to be in `postInstall` so that it runs before
    # `gappsWrapperArgsHook` that runs as one of `preFixupPhases`.
    addToSearchPath GI_TYPELIB_PATH "$lib/lib/girepository-1.0"
  '';

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.malcontent;
      inherit malcontent-ui;
    };
  };

  meta = {
    # We need to install Polkit & AccountsService data files in `out`
    # but `buildEnv` only uses `bin` when both `bin` and `out` are present.
    outputsToInstall = [
      "bin"
      "out"
      "man"
    ];

    description = "Parental controls library";
    mainProgram = "malcontent-client";
    homepage = "https://gitlab.freedesktop.org/pwithnall/malcontent";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ jtojnar ];
    inherit (polkit.meta) platforms badPlatforms;
  };
}
