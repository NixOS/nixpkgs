{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "colemak-dh";
  version = "unstable-2022-08-07";

  src = fetchFromGitHub {
    owner = "ColemakMods";
    repo = "mod-dh";
    rev = "e846a5bd24d59ed15ba70b3a9d5363a38ca51d09";
    sha256 = "sha256-RFOpN+tIMfakb7AZN0ock9eq2mytvL0DWedvQV67+ks=";
    sparseCheckout = [ "console" ];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/keymaps/i386/
    gzip -r ./console
    cp -r ./console $out/share/keymaps/i386/colemak

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://colemakmods.github.io/mod-dh";
    description = "A Colemak mod for more comfortable typing";
    license = licenses.publicDomain;
    platforms = platforms.linux;
    maintainers = with maintainers; [ monaaraj ];
  };
}
