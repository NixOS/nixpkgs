{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "vazir-code-font";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "vazir-code-font";
    rev = "v${version}";
    hash = "sha256-iBojse3eHr4ucZtPfpkN+mmO6sEExY8WcAallyPgMsI=";
  };

  installPhase = ''
    runHook preInstall

    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/truetype {} \;

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/vazir-code-font";
    description = "Persian (farsi) Monospaced Font for coding";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = [ maintainers.dearrude ];
  };
}
