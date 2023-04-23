{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, glib
, python3
, help2man
, systemd
, bash-completion
, bash
, buildPackages
, withIntrospection ? stdenv.hostPlatform.emulatorAvailable buildPackages
, withDocs ? stdenv.hostPlatform == stdenv.buildPlatform
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "libmbim";
  version = "1.28.4";

  outputs = [ "out" "dev" ]
    ++ lib.optionals withDocs [ "man" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mobile-broadband";
    repo = "libmbim";
    rev = version;
    hash = "sha256-aaYjvJ2OMTzkUyqWCyHdmsKJ3VGqBmKQzb1DWK/1cPU=";
  };

  mesonFlags = [
    "-Dudevdir=${placeholder "out"}/lib/udev"
    (lib.mesonBool "introspection" withIntrospection)
    (lib.mesonBool "man" withDocs)
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ] ++ lib.optionals withDocs [
    help2man
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
  ];

  buildInputs = [
    glib
    systemd
    bash-completion
    bash
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs \
      build-aux/mbim-codegen/mbim-codegen
  '';

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/libmbim/";
    description = "Library for talking to WWAN modems and devices which speak the Mobile Interface Broadband Model (MBIM) protocol";
    changelog = "https://gitlab.freedesktop.org/mobile-broadband/libmbim/-/raw/${version}/NEWS";
    maintainers = teams.freedesktop.members;
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
