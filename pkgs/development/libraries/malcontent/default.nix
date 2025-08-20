{ lib, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, gobject-introspection
, wrapGAppsNoGuiHook
, glib
, coreutils
, accountsservice
, dbus
, pam
, polkit
, glib-testing
, python3
, nixosTests
, malcontent-ui
}:

stdenv.mkDerivation rec {
  pname = "malcontent";
  version = "0.13.0";

  outputs = [ "bin" "out" "lib" "pam" "dev" "man" "installedTests" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pwithnall";
    repo = "malcontent";
    rev = version;
    hash = "sha256-DVoTJrpXk5AoRMz+TxEP3NIAA/OOGRzZurLyGp0UBUo=";
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
  ];

  buildInputs = [
    accountsservice
    dbus
    pam
    polkit
    glib-testing
    (python3.withPackages (pp: with pp; [
      pygobject3
    ]))
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

  meta = with lib; {
    # We need to install Polkit & AccountsService data files in `out`
    # but `buildEnv` only uses `bin` when both `bin` and `out` are present.
    outputsToInstall = [ "bin" "out" "man" ];

    description = "Parental controls library";
    mainProgram = "malcontent-client";
    homepage = "https://gitlab.freedesktop.org/pwithnall/malcontent";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
