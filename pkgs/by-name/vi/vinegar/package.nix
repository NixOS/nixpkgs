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
, fetchpatch
, fetchFromGitLab
, fetchurl
,
}:
let
  stagingPatch = fetchFromGitLab {
    sha256 = "sha256-VQ4j4PuXRoXbCUZ16snVO+jRvuKD4Rjn14R7bhwdAco=";
    domain = "gitlab.winehq.org";
    owner = "wine";
    repo = "wine-staging";
    rev = "v9.2";
  };

  wine = wine64Packages.staging.overrideDerivation (oldAttrs: {
    prePatch = ''
      patchShebangs tools
      cp -r ${stagingPatch}/patches ${stagingPatch}/staging .
      chmod +w patches
      patchShebangs ./patches/gitapply.sh
      python3 ./staging/patchinstall.py --destdir="$PWD" --all
    '';
    patches = (oldAttrs.patches or [ ])
      ++ [
      (fetchurl {
        name = "childwindow.patch";
        hash = "sha256-u3mDvlbhQnfh2tUKb8jNJA0tTcLIaKVLfY8ktJmeRns=";
        url = "https://raw.githubusercontent.com/flathub/org.vinegarhq.Vinegar/9f43ce33a691afb50562d95adfc6719a3b58ddb7/patches/wine/childwindow.patch";
      })
      (fetchpatch {
        name = "mouselock.patch";
        hash = "sha256-0AGA4AQbxTL5BGVbm072moav7xVA3zpotYqM8pcEDa4=";
        url = "https://raw.githubusercontent.com/flathub/org.vinegarhq.Vinegar/9f43ce33a691afb50562d95adfc6719a3b58ddb7/patches/wine/mouselock.patch";
      })
      (fetchpatch {
        name = "segregrevert.patch";
        hash = "sha256-+3Nld81nG3GufI4jAF6yrWfkJmsSCOku39rx0Hov29c=";
        url = "https://raw.githubusercontent.com/flathub/org.vinegarhq.Vinegar/9f43ce33a691afb50562d95adfc6719a3b58ddb7/patches/wine/segregrevert.patch";
      })
    ];
    src = fetchFromGitLab rec {
      sha256 = "sha256-GlPH34dr9aHx7xvlcbtDMn/wrY//DP58ilXjhQXgihQ=";
      domain = "gitlab.winehq.org";
      owner = "wine";
      repo = "wine";
      rev = "wine-9.2";
    };
  });
in
buildGoModule rec {
  pname = "vinegar";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "vinegarhq";
    repo = "vinegar";
    rev = "v${version}";
    hash = "sha256-4tkcrUzW8la5WiDtGUvvsRzFqZM1gqnWWAzXc82hirM=";
  };

  vendorHash = "sha256-pi9FjKYXH8cqTx2rTRCyT4+pOM5HnIKosEcmcpbuywQ=";

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
