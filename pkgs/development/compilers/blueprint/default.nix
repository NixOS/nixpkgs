<<<<<<< HEAD
{ dbus
, fetchFromGitLab
, gobject-introspection
, lib
, libadwaita
=======
{ fetchFromGitLab
, gobject-introspection
, gtk4
, lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, meson
, ninja
, python3
, stdenv
, testers
<<<<<<< HEAD
, xvfb-run
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "blueprint-compiler";
  version = "0.10.0";
=======
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "blueprint-compiler";
  version = "0.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jwestman";
    repo = "blueprint-compiler";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-pPrQc2ID84N+50j/A6VAJAOK+D1hjaokhFckOnOaeTw=";
=======
    hash = "sha256-L6EGterkZ8EB6xSnJDZ3IMuOumpTpEGnU74X3UgC7k0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
<<<<<<< HEAD
    libadwaita
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    (python3.withPackages (ps: with ps; [
      pygobject3
    ]))
  ];

  propagatedBuildInputs = [
    # For setup hook, so that the compiler can find typelib files
    gobject-introspection
  ];

<<<<<<< HEAD
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

=======
  doCheck = true;

  nativeCheckInputs = [
    gtk4
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "A markup language for GTK user interface files";
    homepage = "https://gitlab.gnome.org/jwestman/blueprint-compiler";
    license = licenses.lgpl3Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ benediktbroich paveloom ranfdev ];
=======
    maintainers = with maintainers; [ benediktbroich ranfdev ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.unix;
  };
})
