{ dbus
, fetchFromGitLab
, gobject-introspection
, lib
, libadwaita
, meson
, ninja
, python3
, stdenv
, testers
, xvfb-run
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "blueprint-compiler";
  version = "0.10.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jwestman";
    repo = "blueprint-compiler";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pPrQc2ID84N+50j/A6VAJAOK+D1hjaokhFckOnOaeTw=";
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
    dbus
    xvfb-run
  ];

  # requires xvfb-run
  doCheck = !stdenv.isDarwin;

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
    maintainers = with maintainers; [ benediktbroich paveloom ranfdev ];
    platforms = platforms.unix;
  };
})
