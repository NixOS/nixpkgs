{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchPypi,
  fetchurl,
  qt6,
  ffmpeg,
  psmisc,
  util-linux,
  stdenv,
  makeDesktopItem,
  makeWrapper,
  zlib,
  ccache,
  copyDesktopItems,
  config,
  cudaSupport ? config.cudaSupport or false,
  cudaPackages_11 ? { },
  addDriverRunpath ? null,
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
  };

  pyside6-fluent-widgets = python3Packages.buildPythonPackage rec {
    pname = "PySide6-Fluent-Widgets";
    version = "1.8.1";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "zhiyiYo";
      repo = "PyQt-Fluent-Widgets";
      rev = "8e3a36a9bd714c45126f243208791c9c1b8331c9"; # v1.8.1 commit
      hash = "sha256-/7jYH63lA9D68SywodhhY2RUkSOuIRae+Nty66E8+zU=";
    };

    build-system = with python3Packages; [
      setuptools
      wheel
    ];
    dependencies = with python3Packages; [
      pyside6
      darkdetect
      pysidesix-frameless-window
    ];
    doCheck = false;
  };

  pysidesix-frameless-window = python3Packages.buildPythonPackage rec {
    pname = "pysidesix_frameless_window";
    version = "0.7.3";
    pyproject = true;
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-6a9xyTQOYIo0WWuLXVrOvYGAdoFXJNbR21q4FLyDKEQ=";
    };
    build-system = [ python3Packages.setuptools ];
    dependencies = with python3Packages; [ pyside6 ];
    doCheck = false;
  };

  paddlepaddle = python3Packages.buildPythonPackage rec {
    pname = "paddlepaddle" + lib.optionalString cudaSupport "-gpu";
    version = "3.0.0";
    format = "wheel";

    src =
      if cudaSupport then
        fetchurl {
          url = "https://paddle-whl.bj.bcebos.com/stable/cu118/paddlepaddle-gpu/paddlepaddle_gpu-3.0.0-cp312-cp312-manylinux1_x86_64.whl";
          hash = "sha256-h7Q2U61J6XJ+Lv4R3/86t2PvTpdHsx9Ynf1OxnXFctI=";
        }
      else
        fetchPypi {
          inherit pname version format;
          python = "cp312";
          abi = "cp312";
          platform =
            {
              "x86_64-linux" = "manylinux1_x86_64";
              "aarch64-linux" = "manylinux2014_aarch64";
              "x86_64-darwin" = "macosx_10_9_x86_64";
              "aarch64-darwin" = "macosx_11_0_arm64";
            }
            .${stdenv.hostPlatform.system};

          hash =
            {
              "x86_64-linux" = "sha256-gafFsQFQsHUh0c0Ukdyh+3b/YhsU2xDomdlZ86d5Neo=";
              "aarch64-linux" = "sha256-3aqZaosKANvkJp2iHWUFKHfsNpOiLswHucraPs0RaIY=";
              "x86_64-darwin" = "sha256-3P6/sQ3rFaoz0qLWbVoS2d5lRh2KQNJofi+zIhFQ0Lo=";
              "aarch64-darwin" = "sha256-hnfo1C/2b3T7yjL/Mti2S749Vu0pqS1D3EGPDxaPy2k=";
            }
            .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");
        };

    build-system = lib.optionals cudaSupport [ addDriverRunpath ];

    libraryPath = lib.makeLibraryPath (
      [ zlib ]
      ++ lib.optionals cudaSupport (
        with cudaPackages_11;
        [
          cudatoolkit.lib
          cudatoolkit.out
          cudnn_8_6
        ]
      )
    );

    postFixup = lib.optionalString cudaSupport ''
      function fixRunPath {
        p=$(patchelf --print-rpath $1)
        patchelf --set-rpath "$p:$libraryPath" $1
        addDriverRunpath $1
      }
      fixRunPath $out/${python3Packages.python.sitePackages}/paddle/base/libpaddle.so
    '';

    dependencies = with python3Packages; [
      decorator
      protobuf
      httpx
      astor
      opt-einsum
    ];
    doCheck = false;
  };

  paddleocr = python3Packages.buildPythonPackage rec {
    pname = "paddleocr";
    version = "2.10.0";
    format = "wheel";

    src = fetchPypi {
      inherit pname version;
      format = "wheel";
      python = "py3";
      abi = "none";
      platform = "any";
      hash = "sha256-ON+BjYegCvhUy/0U4zYV7cPE+iyutmIUnVHm8uISAT8=";
    };

    dependencies =
      [ paddlepaddle ]
      ++ (with python3Packages; [
        opencv4
        pillow
        numpy
      ]);
    doCheck = false;
  };

  # Qt plugin paths for cross-platform Qt support
  qtPluginPaths = [
    "${qt6.qtbase}/${qt6.qtbase.qtPluginPrefix}"
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ "${qt6.qtwayland}/${qt6.qtbase.qtPluginPrefix}" ];
in
python3Packages.buildPythonApplication rec {
  pname = "video-subtitle-extractor";
  version = "2.1.1";
  pyproject = false;
  __structuredAttrs = true;

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

  build-system = [
    copyDesktopItems
    makeWrapper
    qt6.wrapQtAppsHook
    python3Packages.cython
  ] ++ lib.optionals cudaSupport [ addDriverRunpath ];

  dontWrapQtApps = false;

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

  dependencies = with python3Packages; [
    # Build system
    setuptools

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

  libraryPath = lib.makeLibraryPath (dependencies ++ buildInputs);

  dontBuild = true;

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
    cp -r backend design ui gui.py $out/share/video-subtitle-extractor/

    # Install the icon
    cp design/vse.ico $out/share/icons/hicolor/128x128/apps/video-subtitle-extractor.ico

    # Make the main script executable
    chmod +x $out/share/video-subtitle-extractor/gui.py

    # Create a symbolic link in the bin directory to make the app available in PATH
    ln -s $out/share/video-subtitle-extractor/gui.py $out/bin/video-subtitle-extractor

    runHook postInstall
  '';

  preFixup = ''
    # Wrap the launcher with Qt paths and system tools
    wrapProgram $out/bin/video-subtitle-extractor \
      --prefix QT_PLUGIN_PATH : "${lib.concatStringsSep ":" qtPluginPaths}" \
      --prefix PATH : "${
        lib.makeBinPath [
          ccache
          psmisc
          util-linux
          ffmpeg
        ]
      }" \
      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        --prefix LD_LIBRARY_PATH : "${libraryPath}" \
        --set QT_WAYLAND_TEXT_INPUT_PROTOCOL text-input-v1 \
        --set QT_WAYLAND_DISABLE_WINDOWDECORATION 1 \
        --set-default QT_QPA_PLATFORM "wayland;xcb"
      ''} \
      ${lib.optionalString stdenv.hostPlatform.isDarwin ''
        --prefix DYLD_LIBRARY_PATH : "${libraryPath}"
      ''}
  '';

  doCheck = false;

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
