{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  gettext,
  meson,
  ninja,
  python3,
  sassc,
}:

stdenvNoCC.mkDerivation rec {
  pname = "elementary-gtk-theme";
<<<<<<< HEAD
  version = "8.2.2";
=======
  version = "8.2.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "stylesheet";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-ZjeufUC3Eg1do3GKN1kW/EceuWfAsFnOkSCmscL+vxg=";
=======
    sha256 = "sha256-ymgSe4LKtbJVwmZJOwer1Geb/VgYltp+tSNHkWtaMlg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

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

<<<<<<< HEAD
  meta = {
    description = "GTK theme designed to be smooth, attractive, fast, and usable";
    homepage = "https://github.com/elementary/stylesheet";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
=======
  meta = with lib; {
    description = "GTK theme designed to be smooth, attractive, fast, and usable";
    homepage = "https://github.com/elementary/stylesheet";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
