{ pkgs, lib, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "sddm-sugar-dark";
  version = "1.2";

  src = pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-sugar-dark";
    rev = "v${version}";
    hash = "sha256-C3qB9hFUeuT5+Dos2zFj5SyQegnghpoFV9wHvE9VoD8=";
  };

  propagatedUserEnvPkgs = with pkgs.libsForQt5.qt5; [ qtgraphicaleffects ];

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -r $src $out/share/sddm/themes/sugar-dark
  '';

  meta = with lib; {
    description = "The sugar-dark SDDM theme.";
    longDescription = ''
      Dark SDDM theme from the sugar family.
      It is said to be so sweet, that it causes diabetes just from looking at it.
    '';
    homepage = "https://github.com/MarianArlt/sddm-sugar-dark";
    license = licenses.gpl3;

    platforms = platforms.linux;
    maintainers = with maintainers; [ danid3v ];
  };
}
