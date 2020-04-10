{ stdenv
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, pkgconfig
, gobject-introspection
, wrapGAppsHook
, glib
, coreutils
, accountsservice
, dbus
, pam
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

    # Do not build things that are part of malcontent-ui package
    ./better-separation.patch

    # Fix pam installed test
    # https://gitlab.freedesktop.org/pwithnall/malcontent/merge_requests/50
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/pwithnall/malcontent/commit/5d102eeb0604e65fc977ca77d4b249e986e634cc.patch";
      sha256 = "5PD/eJBw/8Uqcia7ena9mu45DgREBFj0zUJpcd0vQ+8=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gobject-introspection
    wrapGAppsHook
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
    "-Dui=disabled"
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
