{ lib
, stdenvNoCC
, fetchFromGitHub
, fetchpatch
, nix-update-script
, gettext
, meson
, ninja
, python3
, sassc
}:

stdenvNoCC.mkDerivation rec {
  pname = "elementary-gtk-theme";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "stylesheet";
    rev = version;
    sha256 = "sha256-ZR0FJ8DkPlO1Zatvxv3NghAVBPo2j+1m0k4C+gvYPVA=";
  };

  patches = [
    # Headerbars: fix missing default-decoration
    # https://github.com/elementary/stylesheet/pull/1258
    (fetchpatch {
      url = "https://github.com/elementary/stylesheet/commit/9cea2383bec8f90d25f1e9b854b5221737487521.patch";
      sha256 = "sha256-6komROS4+nxwoGoKoiDmnrTfLNZAvnTU6hIEOQQfmxc=";
    })
  ];

  nativeBuildInputs = [
    gettext
    meson
    ninja
    python3
    sassc
  ];

  postPatch = ''
    chmod +x meson/install-to-dir.py
    patchShebangs meson/install-to-dir.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "GTK theme designed to be smooth, attractive, fast, and usable";
    homepage = "https://github.com/elementary/stylesheet";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
