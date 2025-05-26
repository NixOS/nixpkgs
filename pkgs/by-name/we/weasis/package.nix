{
  lib,
  stdenv,
  fetchzip,
  jdk23,
  copyDesktopItems,
  makeDesktopItem,
  makeBinaryWrapper,
  libGL,
  xorg,
}:

let
  throwSystem = throw "Unsupported system: ${stdenv.system}";
  platform =
    {
      "x86_64-linux" = "linux-x86-64";
    }
    .${stdenv.system} or throwSystem;
  runtimeDeps =
    [
      libGL
    ]
    ++ (with xorg; [
      libX11
      libXrender
      libXxf86vm
    ]);
in
stdenv.mkDerivation rec {
  pname = "weasis";
  version = "4.5.1";

  # Their build instructions indicate to use the packaging script
  src = fetchzip {
    url = "https://github.com/nroduit/Weasis/releases/download/v${version}/weasis-native.zip";
    hash = "sha256-aGoTSOZ1W8JHQ0+FcJ9RZ47A1LfXJOoGNmVDiUd9zxE=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "DICOMizer";
      exec = "Dicomizer";
      icon = "Dicomizer";
      desktopName = "DICOMizer";
      comment = "Convert standard images into DICOM";
    })
    (makeDesktopItem {
      name = "Weasis";
      exec = "Weasis";
      icon = "Weasis";
      desktopName = "Weasis";
      comment = meta.description;
    })
  ];

  postPatch = ''
    patchShebangs ./build/script/package-weasis.sh
  '';

  buildPhase = ''
    runHook preBuild

    ./build/script/package-weasis.sh --no-installer --jdk ${jdk23}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt/Weasis/share/{applications,pixmaps}}

    mv weasis-${platform}-jdk${lib.versions.major jdk23.version}-${version}/Weasis/* $out/opt/Weasis
    mv $out/opt/Weasis/lib/*.png $out/opt/Weasis/share/pixmaps/

    makeWrapper $out/opt/Weasis/bin/Weasis $out/bin/Weasis \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeDeps}

    runHook postInstall
  '';

  meta = {
    description = "Multipurpose standalone and web-based DICOM viewer with a highly modular architecture";
    homepage = "https://weasis.org";
    # Using changelog from releases as it is more accurate
    changelog = "https://github.com/nroduit/Weasis/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20
      epl20
    ];
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "Weasis";
  };
}
