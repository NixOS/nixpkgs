{ stdenv
, fetchFromGitLab
, meson
, ninja
, pkgconfig
, gobject-introspection
, wrapGAppsHook
, glib
, coreutils
, dbus
, polkit
, glib-testing
, python3
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "malcontent";
  version = "0.4.0";

  outputs = [ "bin" "out" "dev" "man" "installedTests" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pwithnall";
    repo = pname;
    rev = version;
    sha256 = "0d703r20djvrgy711jvn90i8dwbb0p7qj4j43z101afpkiizq810";
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
    wrapGAppsHook
  ];

  buildInputs = [
    dbus
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
