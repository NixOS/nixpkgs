{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xonitix";
  version = "0-unstable-2021-07-07";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "garu";
    repo = "Xonitix";
    rev = "8d0eba81ff0984d4f1415214c5edb5a8ab1566d0";
    hash = "sha256-pn4WI4u1k9+CoowA+LM6uBvJgRwlYWn8yaosj4HAB6w=";
  };

  buildPhase = ''
    runHook preBuild

    g++ -Wall -std=c++11 xonitix.cpp -o xonitix

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 xonitix $out/bin/xonitix

    runHook postInstall
  '';

  meta = {
    description = "Action-packed game where claim space on the line";
    homepage = "https://github.com/garu/Xonitix";
    mainProgram = "xonitix";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
