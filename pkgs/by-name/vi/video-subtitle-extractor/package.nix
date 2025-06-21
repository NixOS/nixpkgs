{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchPypi,
  qt6,
  ffmpeg,
  psmisc,
  util-linux,
  stdenv,
  makeDesktopItem,
  zlib,
  ccache,
  copyDesktopItems,
  addDriverRunpath,
  cudaPackages_11,
  config,
  cudaSupport ? config.cudaSupport or false,
  imagemagick,
}:

let
  wordsegment = python3Packages.buildPythonPackage rec {
    pname = "wordsegment";
    version = "1.3.1";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-Pcx80em7o/P/5qDlTZg3e8UC/DTp6djIGZrFY2kk8CM=";
    };

    build-system = [ python3Packages.setuptools ];

    doCheck = false;

    meta.license = lib.licenses.asl20;
  };

  paddleocr = python3Packages.buildPythonPackage rec {
    pname = "paddleocr";
    version = "2.10.0";
    format = "wheel";

    src = fetchPypi {
      inherit pname version;
      format = "wheel";
      python = "py3";
      dist = "py3";
      abi = "none";
      platform = "any";
      hash = "sha256-ON+BjYegCvhUy/0U4zYV7cPE+iyutmIUnVHm8uISAT8=";
    };

    dependencies = with python3Packages; [
      paddlepaddle
      opencv4
      pillow
      numpy
    ];

    doCheck = false;

    meta.license = lib.licenses.asl20;
  };
in
python3Packages.buildPythonApplication rec {
  pname = "video-subtitle-extractor";
  version = "2.1.1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "eritpchy";
    repo = "video-subtitle-extractor";
    tag = version;
    hash = "sha256-xEyHkLAErU76JELzIPtvka5N+gAWvOrNYv0PHnVrV9w=";
  };

  # Patches are applied in order to adapt the application for NixOS.
  patches = [
    # 0001: Correct paths to use user's config directory instead of relative paths.
    ./0001-fix-paths-in-config.patch

    # 0002: Fixes relative paths, progress indicator, and Linux process handling.
    ./0002-fix-main-logic.patch

    # 0003: Removes an unused dependency by adjusting model path logic.
    ./0003-remove-unused-dependency.patch

    # 0004: Manages the typo correction map, copying it to a writable user directory.
    ./0004-fix-typomap-logic.patch

    # 0005: Fixes the shell script runner for VideoSubFinder.
    ./0005-fix-videosubfinder-runner.patch

    # 0006: Uses absolute paths for pkill/kill to ensure proper process termination on NixOS.
    ./0006-fix-process-termination-on-nixos.patch

    # 0007: Fixes icon paths in the GUI to be absolute, preventing "file not found" errors.
    ./0007-fix-gui-icon-paths.patch

    # 0008: Removes a window opacity animation that caused warnings on some window managers.
    ./0008-remove-gui-opacity-animation.patch
  ];

  prePatch = ''
    # Normalize line endings before applying patches (convert CRLF to LF)
    find . -name "*.py" -exec sed -i 's/\r$//' {} \;
    find . -name "*.run" -exec sed -i 's/\r$//' {} \;
  '';

  nativeBuildInputs = [
    python3Packages.cython
    copyDesktopItems
    qt6.wrapQtAppsHook
    imagemagick
  ] ++ lib.optionals cudaSupport [ addDriverRunpath ];

  buildInputs =
    [
      qt6.qtbase
      qt6.qtwayland
      ccache
      zlib
      (lib.getLib stdenv.cc.cc)
      ffmpeg
      psmisc
      util-linux
    ]
    ++ lib.optionals cudaSupport (
      with cudaPackages_11;
      [
        cudatoolkit.lib
        cudatoolkit.out
        cudnn_8_6
      ]
    );

  dependencies = with python3Packages; [
    # Core dependencies
    scikit-image
    shapely
    tqdm
    requests
    typing-extensions
    six
    pysrt
    levenshtein
    lmdb
    pyclipper

    # PaddleOCR dependencies (only essential ones)
    attrdict
    beautifulsoup4
    fire
    fonttools
    lxml
    openpyxl
    python-docx
    rapidfuzz
    lanms-neo
    polygon3
    albumentations

    # Custom Python packages
    wordsegment
    paddlepaddle
    paddleocr
    pyside6
    darkdetect
    pyside6-fluent-widgets
    show-in-file-manager
    onnxruntime
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "video-subtitle-extractor";
      exec = "video-subtitle-extractor";
      icon = "video-subtitle-extractor";
      desktopName = "Video Subtitle Extractor";
      comment = "AI-powered video subtitle extraction tool";
      categories = [
        "AudioVideo"
        "Video"
      ];
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall

    # --- Start of model parameters merging ---
    # These steps merge split model files.
    if [ -f backend/models/V2/ch_rec/fs_manifest.csv ]; then
      cd backend/models/V2/ch_rec/ && cat inference_*.pdiparams > inference.pdiparams && cd - > /dev/null
    fi

    if [ -f backend/models/V4/ch_det/fs_manifest.csv ]; then
      cd backend/models/V4/ch_det/ && cat inference_*.pdiparams > inference.pdiparams && cd - > /dev/null
    fi

    # Clean up split model files after merging
    find backend/models -name "fs_manifest.csv" -delete
    find backend/models -name "inference_*.pdiparams" -delete
    # --- End of model parameters merging ---

    # Create necessary directories in the output path
    mkdir -p $out/bin \
             $out/share/video-subtitle-extractor \
             $out/share/icons/hicolor/128x128/apps

    # Copy only the necessary application files to the share directory
    cp -r backend ui gui.py $out/share/video-subtitle-extractor/

    # Install the icon by converting it to PNG
    convert design/vse.ico $out/share/icons/hicolor/128x128/apps/video-subtitle-extractor.png

    # Make the main script executable
    chmod +x $out/share/video-subtitle-extractor/gui.py

    # Create a symbolic link in the bin directory to make the app available in PATH
    ln -s $out/share/video-subtitle-extractor/gui.py $out/bin/video-subtitle-extractor

    runHook postInstall
  '';

  dontWrapQtApps = false;

  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
    "--prefix PATH : ${
      lib.makeBinPath [
        ccache
        psmisc
        util-linux
        ffmpeg
      ]
    }"
  ];

  postFixup = ''
    wrapPythonProgramsIn "$out/share/video-subtitle-extractor" "$out $pythonPath"
  '';

  doCheck = false; # no test

  meta = {
    description = "AI-powered video subtitle extraction tool";
    longDescription = ''
      Video Subtitle Extractor is an advanced subtitle extraction tool that uses AI-powered OCR
      to extract subtitles from video files. ${
        lib.optionalString cudaSupport "This GPU-accelerated version"
        + lib.optionalString (!cudaSupport) "This CPU-only version"
      } provides reliable subtitle
      extraction with PaddlePaddle OCR in multiple languages.
    '';
    changelog = "https://github.com/eritpchy/video-subtitle-extractor/releases/tag/${version}";
    homepage = "https://github.com/eritpchy/video-subtitle-extractor";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ alper-han ];
    mainProgram = "video-subtitle-extractor";
  };
}
