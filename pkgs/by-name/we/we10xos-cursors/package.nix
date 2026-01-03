{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "we10xos-cursors";
  version = "0-unstable-2026-01-02";

  src = fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = "We10XOS-cursors";
    rev = "b971891cc016ba780af791ac9872a15406695ad8";
    hash = "sha256-dy6gA2jZa0pxwXDnc3ckxWd01k2UG0EWG8hoeU5T28Y=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/We10XOS
    cp -r $src/dist/* $out/share/icons/We10XOS/

    runHook postInstall
  '';

  meta = {
    description = "We10XOS cursors for linux desktops";
    homepage = "https://github.com/yeyushengfan258/We10XOS-cursors";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
