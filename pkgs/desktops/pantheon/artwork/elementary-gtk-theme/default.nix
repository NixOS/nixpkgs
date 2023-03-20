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
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "stylesheet";
    rev = version;
    sha256 = "sha256-KUo9IbB10JRgFrn6I5y4+34PEihuwp78b+YsX2Wqip8=";
  };

  patches = [
    # All patches listed below are fixes for Epiphany 44.
    # https://github.com/elementary/browser/discussions/82
    (fetchpatch {
      url = "https://github.com/elementary/stylesheet/commit/c0028159dd5a7767ead9a12e9a4cfb693159c823.patch";
      sha256 = "sha256-JgJ6FoE2aSTmjJ7klAoYXITbxJwy1HFGvr6F6lVQysY=";
    })
    (fetchpatch {
      url = "https://github.com/elementary/stylesheet/commit/2b9aa7aabce8ab2656340de41f7d5194ddd62078.patch";
      sha256 = "sha256-84sCbVw3JChw25FIKG4eFbj3EkDioefJp5Q938TwXPc=";
    })
    (fetchpatch {
      url = "https://github.com/elementary/stylesheet/commit/88682d3e931fdd46682d3ac8f1f1e700e2514c56.patch";
      sha256 = "sha256-2/yYO9Upt33bZembRRuvcfwpQunD1hhJ/BC2DZSuWPk=";
    })
    (fetchpatch {
      url = "https://github.com/elementary/stylesheet/commit/bb15232abc6167a305b4404467498d11901aea69.patch";
      sha256 = "sha256-L6y61CVRTakSHDvFanhbpsSzLkiSp5Dsm0Fg3RKccQk=";
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
