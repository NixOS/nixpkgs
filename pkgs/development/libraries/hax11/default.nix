{ lib
, multiStdenv
, fetchFromGitHub
, libX11
, libXxf86vm
, xorgproto
, unstableGitUpdater
}:

multiStdenv.mkDerivation (finalAttrs: {
  pname = "hax11";
  version = "0-unstable-2024-06-24";

  src = fetchFromGitHub {
    owner = "CyberShadow";
    repo = "hax11";
    rev = "ef955862d7221d7714eafb33e28299eb758f4462";
    hash = "sha256-ND3N1oMUjmDkF7btcFucDxKxxANL9IKf08/6Kt6LX9o=";
  };

  outputs = [ "out" "doc" ];

  buildInputs = [
    libX11
    libXxf86vm
    xorgproto
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 lib32/hax11.so -t $out/lib32/
    install -Dm644 lib64/hax11.so -t $out/lib64/
    install -Dm644 README.md -t $doc/share/doc/hax11/

    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    homepage = "https://github.com/CyberShadow/hax11";
    description = "Hackbrary to Hook and Augment X11 protocol calls";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ AndersonTorres cybershadow ];
    platforms = lib.platforms.linux;
  };
})
