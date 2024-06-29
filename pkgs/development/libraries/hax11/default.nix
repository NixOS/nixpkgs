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
  version = "0-unstable-2023-09-25";

  src = fetchFromGitHub {
    owner = "CyberShadow";
    repo = "hax11";
    rev = "2ea9d469785bbe0338729c4deeb902a259fd7b10";
    hash = "sha256-bYuIngZ76m5IgbbTFTZ8LJmpHl4nHS272Ci1B9eJIws=";
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
