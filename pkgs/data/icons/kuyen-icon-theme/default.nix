{ lib, stdenvNoCC, fetchFromGitLab, gtk3 }:

stdenvNoCC.mkDerivation rec {
  pname = "kuyen-icon-theme";
  version = "747e0e01";

  src = fetchFromGitLab {
    owner = "froodo_alexis";
    repo = "kuyen-icons";
    rev = version;
    sha256 = "sha256-6BK6+6CZhcPgDNuBIF9cYXGwS414NlL+KvRdsDzziaQ=";
  };

  nativeBuildInputs = [ gtk3 ];

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons/kuyen-icons
    cp -r * $out/share/icons/kuyen-icons
  '';

  meta = with lib; {
    description = "A colourful flat theme designed for Plasma desktop";
    homepage = "https://gitlab.com/froodo_alexis/kuyen-icons";
    license = licenses.cc-by-nc-sa-30;
    platforms = platforms.linux;
    maintainers = with maintainers; [ iamanaws ];
  };
}
