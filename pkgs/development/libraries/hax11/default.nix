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
  version = "unstable-2022-12-10";

  src = fetchFromGitHub {
    owner = "CyberShadow";
    repo = "hax11";
    rev = "dce456f2b209f1be18d91064be257b66b69b7d9f";
    hash = "sha256-e3jYvbglQ5Nzoz/B+WEkCw48Tu+i73t+PNq51mjzmjY=";
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
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
