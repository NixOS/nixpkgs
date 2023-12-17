{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  pkg-config,
  libGL,
  libxkbcommon,
  xorg,
  wineWowPackages,
  fetchpatch,
}: let
  # wine-staging doesn't support overrideAttrs for now
  wine = wineWowPackages.stagingFull.overrideDerivation (oldAttrs: {
    patches =
      (oldAttrs.patches or [])
      ++ [
        # upstream issue: https://bugs.winehq.org/show_bug.cgi?id=55604
        # Here are the currently applied patches for Roblox to run under WINE:
        (fetchpatch {
          name = "vinegar-wine-segrevert.patch";
          url = "https://raw.githubusercontent.com/flathub/org.vinegarhq.Vinegar/8fc153c492542a522d6cc2dff7d1af0e030a529a/patches/wine/temp.patch";
          hash = "sha256-AnEBBhB8leKP0xCSr6UsQK7CN0NDbwqhe326tJ9dDjc=";
        })
      ];
  });
in
  buildGoModule rec {
    pname = "vinegar";
    version = "1.5.9";

    src = fetchFromGitHub {
      owner = "vinegarhq";
      repo = "vinegar";
      rev = "v${version}";
      hash = "sha256-cLzQnNmQYyAIdTGygk/CNU/mxGgcgoFTg5G/0DNwpz4=";
    };

    vendorHash = "sha256-DZI4APnrldnwOmLZ9ucFBGQDxzPXTIi44eLu74WrSBI=";

    nativeBuildInputs = [pkg-config makeBinaryWrapper];
    buildInputs = [libGL libxkbcommon xorg.libX11 xorg.libXcursor xorg.libXfixes wine];

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
      platforms = ["x86_64-linux" "i686-linux"];
      maintainers = with maintainers; [nyanbinary];
    };
  }
