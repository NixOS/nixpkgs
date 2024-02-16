{ lib
, buildGoModule
, fetchFromGitHub
, makeBinaryWrapper
, pkg-config
, libGL
, libxkbcommon
, xorg
, wayland
, vulkan-headers
, wine64Packages
}:
let
  wine = wine64Packages.stable.overrideDerivation (oldAttrs: {
    patches =
      (oldAttrs.patches or [ ])
      ++ [
        # upstream issue: https://bugs.winehq.org/show_bug.cgi?id=55604
        # Here are the currently applied patches for Roblox to run under WINE:
        ./patches/segregrevert.mypatch
      ];
  });
in
buildGoModule rec {
  pname = "vinegar";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "vinegarhq";
    repo = "vinegar";
    rev = "v${version}";
    hash = "sha256-uRdWE5NwRVSuUZyU5B5u5DfJOxu/gUqwM682eORTDOs=";
  };

  vendorHash = "sha256-Ex6PRd3rD2jbLXlY36koNvZF3P+gAZTE9hExIfOw9CE=";

  nativeBuildInputs = [ pkg-config makeBinaryWrapper ];
  buildInputs = [ libGL libxkbcommon xorg.libX11 xorg.libXcursor xorg.libXfixes wayland vulkan-headers wine ];

  buildPhase = ''
    runHook preBuild
    make PREFIX=$out
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make PREFIX=$out install
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/vinegar \
      --prefix PATH : ${lib.makeBinPath [wine]}
  '';

  meta = with lib; {
    description = "An open-source, minimal, configurable, fast bootstrapper for running Roblox on Linux";
    homepage = "https://github.com/vinegarhq/vinegar";
    changelog = "https://github.com/vinegarhq/vinegar/releases/tag/v${version}";
    mainProgram = "vinegar";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ nyanbinary ];
  };
}
