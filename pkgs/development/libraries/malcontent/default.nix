{ stdenv
, fetchFromGitLab
, meson
, ninja
, pkgconfig
, gobject-introspection
, wrapGAppsHook
, glib
, coreutils
, accountsservice
, dbus
, flatpak
, gtk3
, pam
, desktop-file-utils
, polkit
, glib-testing
, python3
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "malcontent";
  version = "0.6.0";

  outputs = [ "bin" "out" "dev" "man" "installedTests" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pwithnall";
    repo = pname;
    rev = version;
    sha256 = "COh6N3CmLIcxx6tW4jcP0m6TZv0Z1YJUM/nlG0RzYHQ=";
  };

  patches = [
    # Allow installing installed tests to a separate output.
    ./installed-tests-path.patch

    # This is unnecessary and breaks when submodules are not available.
    # https://gitlab.freedesktop.org/pwithnall/malcontent/merge_requests/3
    ./use-system-dependencies.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gobject-introspection
    desktop-file-utils
    wrapGAppsHook
  ];

  buildInputs = [
    accountsservice
    dbus
    flatpak
    gtk3
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
  ];

  postPatch = ''
    substituteInPlace libmalcontent/tests/app-filter.c \
      --replace "/usr/bin/true" "${coreutils}/bin/true" \
      --replace "/bin/true" "${coreutils}/bin/true" \
      --replace "/usr/bin/false" "${coreutils}/bin/false" \
      --replace "/bin/false" "${coreutils}/bin/false"
  '';

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.malcontent;
    };
  };

  meta = with stdenv.lib; {
    description = "Parental controls library";
    homepage = "https://gitlab.freedesktop.org/pwithnall/malcontent";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
