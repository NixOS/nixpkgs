{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  oldest-supported-numpy,
  setuptools,

  # nativeBuildInputs
  copyDesktopItems,
  cython,
  qt5,
  recommonmark,
  sphinx,

  # dependencies
  baycomp,
  bottleneck,
  catboost,
  chardet,
  httpx,
  joblib,
  keyring,
  keyrings-alt,
  matplotlib,
  numpy,
  openpyxl,
  opentsne,
  orange-canvas-core,
  orange-widget-base,
  pandas,
  pip,
  pyqt5,
  pyqtgraph,
  pyqtwebengine,
  python-louvain,
  pyyaml,
  qtconsole,
  requests,
  scikit-learn,
  scipy,
  serverfiles,
  xgboost,
  xlrd,
  xlsxwriter,

  makeDesktopItem,

  # passthru
  gitUpdater,
  python,
  pytest-qt,
  pytestCheckHook,
}:

let
  self = buildPythonPackage rec {
    pname = "orange3";
    version = "3.39.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "biolab";
      repo = "orange3";
      tag = version;
      hash = "sha256-P2e3Wq33UXnTmGSxkoW8kYYCBfYBB9Z50v4g7n//Fbw=";
    };

    build-system = [
      oldest-supported-numpy
      setuptools
    ];

    postPatch = ''
      substituteInPlace pyproject.toml \
          --replace-fail 'cython>=3.0' 'cython'

      # disable update checking
      echo -e "def check_for_updates():\n\tpass" >> Orange/canvas/__main__.py
    '';

    nativeBuildInputs = [
      copyDesktopItems
      cython
      qt5.wrapQtAppsHook
      recommonmark
      sphinx
    ];

    enableParallelBuilding = true;

    pythonRelaxDeps = [ "scikit-learn" ];

    dependencies = [
      baycomp
      bottleneck
      catboost
      chardet
      httpx
      joblib
      keyring
      keyrings-alt
      matplotlib
      numpy
      openpyxl
      opentsne
      orange-canvas-core
      orange-widget-base
      pandas
      pip
      pyqt5
      pyqtgraph
      pyqtwebengine
      python-louvain
      pyyaml
      qtconsole
      requests
      scikit-learn
      scipy
      serverfiles
      setuptools
      xgboost
      xlrd
      xlsxwriter
    ];

    # FIXME: ImportError: cannot import name '_variable' from partially initialized module 'Orange.data' (most likely due to a circular import) (/build/source/Orange/data/__init__.py)
    doCheck = false;

    # FIXME: pythonRelaxDeps is not relaxing the scikit-learn version constraint, had to disable this
    dontCheckRuntimeDeps = true;

    pythonImportsCheck = [
      "Orange"
      "Orange.data._variable"
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "orange";
        exec = "orange-canvas";
        desktopName = "Orange Data Mining";
        genericName = "Data Mining Suite";
        comment = "Explore, analyze, and visualize your data";
        icon = "orange-canvas";
        mimeTypes = [ "application/x-extension-ows" ];
        categories = [
          "Science"
          "Education"
          "ArtificialIntelligence"
          "DataVisualization"
          "NumericalAnalysis"
          "Qt"
        ];
        keywords = [
          "Machine Learning"
          "Scientific Visualization"
          "Statistical Analysis"
        ];
      })
    ];

    postInstall = ''
      wrapProgram $out/bin/orange-canvas \
        "${"$"}{qtWrapperArgs[@]}"
      mkdir -p $out/share/icons/hicolor/{256x256,48x48}/apps
      cp distribute/icon-256.png $out/share/icons/hicolor/256x256/apps/orange-canvas.png
      cp distribute/icon-48.png $out/share/icons/hicolor/48x48/apps/orange-canvas.png
    '';

    passthru = {
      updateScript = gitUpdater { };
      tests.unittests = stdenv.mkDerivation {
        name = "${self.name}-tests";
        inherit (self) src;

        preCheck = ''
          export HOME=$(mktemp -d)
          export QT_PLUGIN_PATH="${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}"
          export QT_QPA_PLATFORM_PLUGIN_PATH="${qt5.qtbase.bin}/lib/qt-${qt5.qtbase.version}/plugins";
          export QT_QPA_PLATFORM=offscreen

          rm Orange -rf
          cp -r ${self}/${python.sitePackages}/Orange .
          chmod +w -R .

          substituteInPlace Orange/classification/tests/test_xgb_cls.py \
            --replace-fail test_learners mk_test_learners

          substituteInPlace Orange/modelling/tests/test_xgb.py \
            --replace-fail test_learners mk_test_learners

          substituteInPlace Orange/**/tests/*.py \
            --replace-fail test_filename filename_test

          # TODO: debug why orange is crashing on GC, may be a upstream issue
          chmod +x Orange/__init__.py
          echo "import gc; gc.disable()" | tee -a Orange/__init__.py

        '';

        nativeBuildInputs = [
          pytest-qt
          pytestCheckHook
        ];

        postCheck = ''
          touch $out
        '';

        doBuild = false;
        doInstall = false;

        buildInputs = [ self ];
      };
    };

    meta = {
      description = "Data mining and visualization toolbox for novice and expert alike";
      homepage = "https://orangedatamining.com/";
      changelog = "https://github.com/biolab/orange3/blob/${src.tag}/CHANGELOG.md";
      license = [ lib.licenses.gpl3Plus ];
      maintainers = [ ];
      mainProgram = "orange-canvas";
    };
  };
in
self
