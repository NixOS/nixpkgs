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
  version = "0.7.0";

  outputs = [ "bin" "out" "dev" "man" "installedTests" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pwithnall";
    repo = pname;
    rev = version;
    sha256 = "cP2l6nl6cuBQYwkmBj8APu/vH3jTeScXf3ffcuSfqlM=";
  };

  patches = [
    # Allow installing installed tests to a separate output.
    ./installed-tests-path.patch
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
