{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "behdad-fonts";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "font-store";
    repo = "BehdadFont";
    rev = "v${version}";
    hash = "sha256-gKfzxo3/bCMKXl2d6SP07ahIiNrUyrk/SN5XLND2lWY=";
  };

  installPhase = ''
    runHook preInstall

    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/behrad-fonts {} \;

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/font-store/BehdadFont";
    description = "A Persian/Arabic Open Source Font";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
