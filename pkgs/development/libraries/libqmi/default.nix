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
, libgudev
, bash-completion
, libmbim
, libqrtr-glib
}:

stdenv.mkDerivation rec {
  pname = "libqmi";
  version = "1.32.2";

  outputs = [ "out" "dev" "devdoc" ];

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
    gobject-introspection
    python3
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    help2man
  ];

  buildInputs = [
    libgudev
    bash-completion
    libmbim
  ];

  propagatedBuildInputs = [
    glib
    libqrtr-glib
  ];

  mesonFlags = [
    "-Dudevdir=${placeholder "out"}/lib/udev"
    (lib.mesonBool "gtk_doc" (stdenv.buildPlatform == stdenv.hostPlatform))
    (lib.mesonBool "introspection" (stdenv.buildPlatform == stdenv.hostPlatform))
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
