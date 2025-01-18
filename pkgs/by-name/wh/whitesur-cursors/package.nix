{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "whitesur-cursors";
  version = "0-unstable-2022-06-17";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "WhiteSur-cursors";
    rev = "5c94e8c22de067282f4cf6d782afd7b75cdd08c8";
    hash = "sha256-CFse0XZzJu+PWDcqmvIXvue+3cKX47oavZU9HYRDAg0=";
  };

  installPhase = ''
    runHook preInstall
    install -dm 755 $out/share/icons/WhiteSur-cursors
    cp -r dist/* $out/share/icons/WhiteSur-cursors
    runHook postInstall
  '';

  meta = with lib; {
    description = "X-cursor theme inspired by macOS and based on capitaine-cursors";
    homepage = "https://github.com/vinceliuice/WhiteSur-cursors";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tomasajt ];
    platforms = platforms.linux;
  };
}
