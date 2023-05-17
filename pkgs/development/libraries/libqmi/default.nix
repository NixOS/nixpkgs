{ lib
, stdenv
, fetchFromGitLab
, fetchpatch2
, meson
, ninja
, pkg-config
, gobject-introspection
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, help2man
, glib
, python3
, mesonEmulatorHook
, libgudev
, bash-completion
, libmbim
, libqrtr-glib
, buildPackages
, withIntrospection ? stdenv.hostPlatform.emulatorAvailable buildPackages
, withMan ? stdenv.buildPlatform.canExecute stdenv.hostPlatform
}:

stdenv.mkDerivation rec {
  pname = "libqmi";
  version = "1.32.2";

  outputs = [ "out" "dev" ]
    ++ lib.optional withIntrospection "devdoc";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mobile-broadband";
    repo = "libqmi";
    rev = version;
    hash = "sha256-XIbeWgkPiJL8hN8Rb6KFt5Q5sG3KsiEQr0EnhwmI6h8=";
  };

  patches = [
    # Fix pkg-config file missing qrtr in Requires.
    # https://gitlab.freedesktop.org/mobile-broadband/libqmi/-/issues/99
    (fetchpatch2 {
      url = "https://gitlab.freedesktop.org/mobile-broadband/libqmi/-/commit/7d08150910974c6bd2c29f887c2c6d4a3526e085.patch";
      hash = "sha256-LFrlm2ZqLqewLGO2FxL5kFYbZ7HaxdxvVHsFHYSgZ4Y=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ] ++ lib.optionals withMan [
    help2man
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ] ++ lib.optionals (withIntrospection && !stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    bash-completion
    libmbim
  ] ++ lib.optionals withIntrospection [
    libgudev
  ];

  propagatedBuildInputs = [
    glib
  ] ++ lib.optionals withIntrospection [
    libqrtr-glib
  ];

  mesonFlags = [
    "-Dudevdir=${placeholder "out"}/lib/udev"
    (lib.mesonBool "gtk_doc" withIntrospection)
    (lib.mesonBool "introspection" withIntrospection)
    (lib.mesonBool "man" withMan)
    (lib.mesonBool "qrtr" withIntrospection)
    (lib.mesonBool "udev" withIntrospection)
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs \
      build-aux/qmi-codegen/qmi-codegen
  '';

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/libqmi/";
    description = "Modem protocol helper library";
    maintainers = teams.freedesktop.members;
    platforms = platforms.linux;
    license = with licenses; [
      # Library
      lgpl2Plus
      # Tools
      gpl2Plus
    ];
    changelog = "https://gitlab.freedesktop.org/mobile-broadband/libqmi/-/blob/${version}/NEWS";
  };
}
