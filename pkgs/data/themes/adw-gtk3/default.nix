{ stdenvNoCC
, lib
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, sassc
}:

stdenvNoCC.mkDerivation rec {
  pname = "adw-gtk3";
  version = "5.2";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-S6Yo67DTyRzS9uz/6g87SRmfPIBmAKfy4c23M5aENNg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];

  postPatch = ''
    chmod +x gtk/src/adw-gtk3-dark/gtk-3.0/install-dark-theme.sh
    patchShebangs gtk/src/adw-gtk3-dark/gtk-3.0/install-dark-theme.sh
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "The theme from libadwaita ported to GTK-3";
    homepage = "https://github.com/lassekongo83/adw-gtk3";
    license = licenses.lgpl21Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ciferkey ];
  };
}
