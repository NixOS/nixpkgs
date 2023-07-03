{ dbus
, fetchFromGitLab
, gobject-introspection
, gtk4
, lib
, libadwaita
, makeFontsConf
, meson
, ninja
, python3
, stdenv
, testers
, xvfb-run
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "blueprint-compiler";
  version = "0.8.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jwestman";
    repo = "blueprint-compiler";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3lj9BMN5aNujbhhZjObdTOCQfH5ERQCgGqIAw5eZIQc=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    libadwaita
    (python3.withPackages (ps: with ps; [
      pygobject3
    ]))
  ];

  propagatedBuildInputs = [
    # For setup hook, so that the compiler can find typelib files
    gobject-introspection
  ];

  nativeCheckInputs = [
    xvfb-run
    dbus
    gtk4
  ];

  env = {
    # Fontconfig error: Cannot load default config file: No such file: (null)
    FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };
  };

  doCheck = true;

  preBuild = ''
    # Fontconfig error: No writable cache directories
    export XDG_CACHE_HOME="$(mktemp -d)"
  '';

  checkPhase = ''
    runHook preCheck

    xvfb-run dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test --no-rebuild --print-errorlogs

    runHook postCheck
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "A markup language for GTK user interface files";
    homepage = "https://gitlab.gnome.org/jwestman/blueprint-compiler";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ benediktbroich ranfdev ];
    platforms = platforms.linux;
  };
})
