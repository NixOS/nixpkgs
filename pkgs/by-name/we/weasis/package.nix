{
  lib,
  stdenv,
  fetchzip,
  jre,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  throwSystem = throw "Unsupported system: ${stdenv.system}";
  platform =
    {
      "x86_64-linux" = "linux-x86-64";
    }
    .${stdenv.system} or throwSystem;

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

    ./build/script/package-weasis.sh --no-installer --jdk ${jre}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{applications,pixmaps}

    mv weasis-${platform}-jdk${lib.versions.major jre.version}-${version}/Weasis/* $out/
    mv $out/lib/*.png $out/share/pixmaps/

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
