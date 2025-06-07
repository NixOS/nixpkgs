{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
  fetchurl,
  qt6,
  ffmpeg,
  stdenv,
  makeDesktopItem,
  makeWrapper,
  zlib,
  ccache,
  copyDesktopItems,
  dos2unix,
  config,
  cudaSupport ? config.cudaSupport or false,
  cudaPackages_11 ? { },
  addDriverRunpath ? null,
}:

let
  wordsegment = python3.pkgs.buildPythonPackage rec {
    pname = "wordsegment";
    version = "1.3.1";
    pyproject = true;
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-Pcx80em7o/P/5qDlTZg3e8UC/DTp6djIGZrFY2kk8CM=";
    };
    build-system = [ python3.pkgs.setuptools ];
    doCheck = false;
  };

  pyside6-fluent-widgets = python3.pkgs.buildPythonPackage rec {
    pname = "PySide6-Fluent-Widgets";
    version = "1.8.1";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "zhiyiYo";
      repo = "PyQt-Fluent-Widgets";
      rev = "8e3a36a9bd714c45126f243208791c9c1b8331c9"; # v1.8.1 commit
      hash = "sha256-/7jYH63lA9D68SywodhhY2RUkSOuIRae+Nty66E8+zU=";
    };

    build-system = with python3.pkgs; [
      setuptools
      wheel
    ];
    dependencies = with python3.pkgs; [
      pyside6
      darkdetect
      pysidesix-frameless-window
    ];
    doCheck = false;
  };

  pysidesix-frameless-window = python3.pkgs.buildPythonPackage rec {
    pname = "pysidesix_frameless_window";
    version = "0.7.3";
    pyproject = true;
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-6a9xyTQOYIo0WWuLXVrOvYGAdoFXJNbR21q4FLyDKEQ=";
    };
    build-system = [ python3.pkgs.setuptools ];
    dependencies = with python3.pkgs; [ pyside6 ];
    doCheck = false;
  };

  paddlepaddle = python3.pkgs.buildPythonPackage rec {
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
      fixRunPath $out/${python3.sitePackages}/paddle/base/libpaddle.so
    '';

    dependencies = with python3.pkgs; [
      decorator
      protobuf
      httpx
      astor
      opt-einsum
    ];
    doCheck = false;
  };

  paddleocr = python3.pkgs.buildPythonPackage rec {
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
      ++ (with python3.pkgs; [
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
python3.pkgs.buildPythonApplication rec {
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

  patches = [
    ./001-fix-config-file-path.patch
    ./002-set-default-subtitle-language-english.patch
    ./003-set-default-theme-dark.patch
    ./004-set-default-interface-language-english.patch
    ./005-disable-update-check-startup.patch
    ./006-fix-output-paths.patch
    ./007-fix-import-line-continuation.patch
    ./009-fix-typomap-config-path.patch
    ./010-fix-backend-main-basic.patch
    ./011-remove-filesplit-dependency.patch
  ];

  prePatch = ''
    # Fix line endings before applying patches to avoid patch failures
    find . -name "*.py" -exec dos2unix {} \;
  '';

  buildInputs =
    [
      qt6.qtbase
      ccache
      zlib
      (lib.getLib stdenv.cc.cc)
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
    dos2unix
    python3.pkgs.cython
  ] ++ lib.optionals cudaSupport [ addDriverRunpath ];

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    makeWrapperArgs+=("--prefix" "PYTHONPATH" ":" "$out/share/video-subtitle-extractor")
  '';

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

  dependencies =
    with python3.pkgs;
    [
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
    ]
    ++ [ ffmpeg ];

  libraryPath = lib.makeLibraryPath (dependencies ++ buildInputs);

  makeWrapperArgs =
    [
      "--prefix"
      "QT_PLUGIN_PATH"
      ":"
      (lib.concatStringsSep ":" qtPluginPaths)
      "--prefix"
      "PATH"
      ":"
      "${ccache}/bin"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "--prefix"
      "LD_LIBRARY_PATH"
      ":"
      libraryPath
      "--set"
      "QT_WAYLAND_TEXT_INPUT_PROTOCOL"
      "text-input-v1"
      "--set"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION"
      "1"
      "--set"
      "QT_LOGGING_RULES"
      "qt.qpa.wayland.textinput.debug=false;qt.qpa.wayland.textinput.warning=false"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "--prefix"
      "DYLD_LIBRARY_PATH"
      ":"
      libraryPath
    ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    if [ -f backend/models/V2/ch_rec/fs_manifest.csv ]; then
      cd backend/models/V2/ch_rec/ && cat inference_*.pdiparams > inference.pdiparams && cd - > /dev/null
    fi

    if [ -f backend/models/V4/ch_det/fs_manifest.csv ]; then
      cd backend/models/V4/ch_det/ && cat inference_*.pdiparams > inference.pdiparams && cd - > /dev/null
    fi

    find backend/models -name "fs_manifest.csv" -delete
    find backend/models -name "inference_*.pdiparams" -delete

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      sed -i 's|chmod +x ./VideoSubFinderCli|# chmod +x ./VideoSubFinderCli  # Disabled for NixOS read-only filesystem|g' backend/subfinder/linux/VideoSubFinderCli.run
      sed -i 's|cd .*|# Stay in temp directory - do not cd to original dir|g' backend/subfinder/linux/VideoSubFinderCli.run
      sed -i 's|export LD_LIBRARY_PATH=.*|# Binary is now in same directory as wrapper|g' backend/subfinder/linux/VideoSubFinderCli.run
      sed -i 's|export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$ORIGINAL_DIR:/lib64"|export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:.:/lib64"|g' backend/subfinder/linux/VideoSubFinderCli.run
      sed -i '/cp.*VideoSubFinderCli/d' backend/subfinder/linux/VideoSubFinderCli.run
      sed -i '/chmod.*VideoSubFinderCli/d' backend/subfinder/linux/VideoSubFinderCli.run

      sed -i "s|path_vsf = os.path.join(BASE_DIR, 'subfinder', 'linux', 'VideoSubFinderCli.run')|# Copy VideoSubFinderCli wrapper to temp directory to avoid read-only filesystem issues\\n            temp_dir = tempfile.mkdtemp(prefix='vsf_')\\n            vsf_temp_wrapper = os.path.join(temp_dir, 'VideoSubFinderCli.run')\\n            vsf_temp_binary = os.path.join(temp_dir, 'VideoSubFinderCli')\\n            vsf_temp_settings = os.path.join(temp_dir, 'settings')\\n            original_wrapper = os.path.join(BASE_DIR, 'subfinder', 'linux', 'VideoSubFinderCli.run')\\n            original_binary = os.path.join(BASE_DIR, 'subfinder', 'linux', 'VideoSubFinderCli')\\n            original_settings = os.path.join(BASE_DIR, 'subfinder', 'linux', 'settings')\\n            # Copy wrapper, binary, and settings to temp directory\\n            shutil.copy2(original_wrapper, vsf_temp_wrapper)\\n            shutil.copy2(original_binary, vsf_temp_binary)\\n            shutil.copytree(original_settings, vsf_temp_settings)\\n            # Make executable\\n            os.chmod(vsf_temp_wrapper, 0o755)\\n            os.chmod(vsf_temp_binary, 0o755)\\n            # Convert video path to absolute path before changing directory\\n            self.video_path = os.path.abspath(self.video_path)\\n            # Convert output paths to absolute paths\\n            self.temp_output_dir = os.path.abspath(self.temp_output_dir)\\n            self.vsf_subtitle = os.path.abspath(self.vsf_subtitle)\\n            # Change working directory to temp directory so logs can be written\\n            original_cwd = os.getcwd()\\n            os.chdir(temp_dir)\\n            path_vsf = vsf_temp_wrapper|g" backend/main.py
    ''}

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      sed -i "s|os.path.join(BASE_DIR, 'subfinder', 'linux', 'VideoSubFinderCli.run')|os.path.join(BASE_DIR, 'subfinder', 'windows', 'VideoSubFinderCli.exe')|g" backend/main.py

      sed -i "s|path_vsf = os.path.join(BASE_DIR, 'subfinder', 'windows', 'VideoSubFinderCli.exe')|# Copy VideoSubFinderCli to temp directory to avoid read-only filesystem issues (Darwin)\\n            temp_dir = tempfile.mkdtemp(prefix='vsf_darwin_')\\n            vsf_temp_binary = os.path.join(temp_dir, 'VideoSubFinderCli.exe')\\n            vsf_temp_settings = os.path.join(temp_dir, 'settings')\\n            original_binary = os.path.join(BASE_DIR, 'subfinder', 'windows', 'VideoSubFinderCli.exe')\\n            original_settings = os.path.join(BASE_DIR, 'subfinder', 'windows', 'settings')\\n            # Copy binary and settings to temp directory\\n            shutil.copy2(original_binary, vsf_temp_binary)\\n            if os.path.exists(original_settings):\\n                shutil.copytree(original_settings, vsf_temp_settings)\\n            # Make executable\\n            os.chmod(vsf_temp_binary, 0o755)\\n            # Convert video path to absolute path before changing directory\\n            self.video_path = os.path.abspath(self.video_path)\\n            # Convert output paths to absolute paths\\n            self.temp_output_dir = os.path.abspath(self.temp_output_dir)\\n            self.vsf_subtitle = os.path.abspath(self.vsf_subtitle)\\n            # Change working directory to temp directory so logs can be written\\n            original_cwd = os.getcwd()\\n            os.chdir(temp_dir)\\n            path_vsf = vsf_temp_binary|g" backend/main.py
    ''}

    ${lib.optionalString (stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isDarwin) ''
      sed -i '/self.vsf_running = False/a\\        # Restore original working directory\\n        os.chdir(original_cwd)' backend/main.py
    ''}

    mkdir -p $out/bin $out/share/video-subtitle-extractor $out/share/icons/hicolor/128x128/apps
    cp -r . $out/share/video-subtitle-extractor/

    cp design/vse.ico $out/share/icons/hicolor/128x128/apps/video-subtitle-extractor.ico

    install -Dm755 ${./launcher.py} $out/bin/video-subtitle-extractor

    runHook postInstall
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
