{ lib, stdenvNoCC, fetchFromGitHub, jdupes }:

stdenvNoCC.mkDerivation {
  pname = "dracula-icon-theme";
  version = "unstable-2021-07-21";

  src = fetchFromGitHub {
    owner = "m4thewz";
    repo = "dracula-icons";
    rev = "2d3c83caa8664e93d956cfa67a0f21418b5cdad8";
    hash = "sha256-GY+XxTM22jyNq8kaB81zNfHRhfXujArFcyzDa8kjxCQ=";
  };

  nativeBuildInputs = [
    jdupes
  ];

  dontDropIconThemeCache = true;

  dontPatchELF = true;
  dontRewriteSymlinks = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons/Dracula
    cp -a * $out/share/icons/Dracula/
    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "Dracula Icon theme";
    homepage = "https://github.com/m4thewz/dracula-icons";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ therealr5 ];
  };
}
