{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "libre-franklin";
  version = "1.014";

  src = fetchFromGitHub {
    owner = "impallari";
    repo = "Libre-Franklin";
    rev = "006293f34c47bd752fdcf91807510bc3f91a0bd3";
    hash = "sha256-GR1KHiQ1lTOmU8eAPR2pxUlMpWiW2EDMG78VDjELxDU=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/opentype */OTF/*.otf
    install -m444 -Dt $out/share/doc/${pname}-${version} README.md FONTLOG.txt

    runHook postInstall
  '';

  meta = with lib; {
    description = "A reinterpretation and expansion based on the 1912 Morris Fuller Benton’s classic.";
    homepage = "https://github.com/impallari/Libre-Franklin";
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
