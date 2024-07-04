{ lib, stdenvNoCC, fetchFromGitHub }:

let version = "0.91.12"; in
stdenvNoCC.mkDerivation {
  pname = "open-dyslexic";
  inherit version;

  src = fetchFromGitHub {
    owner = "antijingoist";
    repo = "opendyslexic";
    rev = "v${version}";
    hash = "sha256-a8hh8NGt5djj9EC7ChO3SnnjuYMOryzbHWTK4gC/vIw=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 compiled/*.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://opendyslexic.org/";
    description = "Font created to increase readability for readers with dyslexia";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
