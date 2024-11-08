{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "vazir-fonts";
  version = "33.003";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "vazir-font";
    rev = "v${version}";
    hash = "sha256-C1UtfrRFzz0uv/hj8e7huXe4sNd5h7ozVhirWEAyXGg=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/truetype {} \;

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/vazir-font";
    description = "Persian (Farsi) Font - قلم (فونت) فارسی وزیر";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
