{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeDesktopItem,
  patsh,
  xorg,
  nixosTests,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sx";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "earnestly";
    repo = "sx";
    rev = finalAttrs.version;
    hash = "sha256-hKoz7Kuus8Yp7D0F05wCOQs6BvV0NkRM9uUXTntLJxQ=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ patsh ];

  buildInputs = [
    xorg.xauth
    xorg.xorgserver
  ];

  postInstall = ''
    patsh -f $out/bin/sx -s ${builtins.storeDir}

    install -Dm755 -t $out/share/xsessions ${
      makeDesktopItem {
        name = "sx";
        desktopName = "sx";
        comment = "Start a xorg server";
        exec = "sx";
      }
    }/share/applications/sx.desktop
  '';

  passthru = {
    providedSessions = [ "sx" ];
    tests = {
      inherit (nixosTests) sx;
    };
  };

  meta = {
    description = "Simple alternative to both xinit and startx for starting a Xorg server";
    homepage = "https://github.com/earnestly/sx";
    license = lib.licenses.mit;
    mainProgram = "sx";
    maintainers = with lib.maintainers; [
      figsoda
      thiagokokada
    ];
    platforms = lib.platforms.linux;
  };
})
