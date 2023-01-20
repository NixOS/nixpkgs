{ lib
, stdenvNoCC
, fetchFromGitHub
, nix-update-script
, gettext
, meson
, ninja
, python3
, sassc
}:

stdenvNoCC.mkDerivation rec {
  pname = "elementary-gtk-theme";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "stylesheet";
    rev = version;
    sha256 = "sha256-ZnQ54ktH0/ZyFH6c180YzbkK/TyIDziiwAXi/zqHpe4=";
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
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "GTK theme designed to be smooth, attractive, fast, and usable";
    homepage = "https://github.com/elementary/stylesheet";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
