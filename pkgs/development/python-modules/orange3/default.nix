{
  lib,
  stdenv,
  baycomp,
  bottleneck,
  buildPythonPackage,
  chardet,
  copyDesktopItems,
  cython,
  catboost,
  xgboost,
  fetchFromGitHub,
  fetchurl,
  httpx,
  joblib,
  keyring,
  keyrings-alt,
  makeDesktopItem,
  matplotlib,
  nix-update-script,
  numpy,
  oldest-supported-numpy,
  openpyxl,
  opentsne,
  orange-canvas-core,
  orange-widget-base,
  pandas,
  pytestCheckHook,
  pytest-qt,
  pyqtgraph,
  pyqtwebengine,
  python,
  python-louvain,
  pythonOlder,
  pyyaml,
  pip,
  qt5,
  qtconsole,
  recommonmark,
  requests,
  scikit-learn,
  scipy,
  serverfiles,
  setuptools,
  sphinx,
  wheel,
  xlrd,
  xlsxwriter,
}:

let
  self = buildPythonPackage rec {
    pname = "orange3";
    version = "3.36.2";
    pyproject = true;

    disabled = pythonOlder "3.7";

    src = fetchFromGitHub {
      owner = "biolab";
      repo = "orange3";
      rev = "refs/tags/${version}";
      hash = "sha256-v9lk5vGhBaR2PHZ+Jq0hy1WaCsbeLe+vZlTaHBkfacU=";
    };

    postPatch = ''
      substituteInPlace pyproject.toml \
          --replace-fail 'cython>=3.0' 'cython'

      # disable update checking
      echo -e "def check_for_updates():\n\tpass" >> Orange/canvas/__main__.py
    '';

    nativeBuildInputs = [
      copyDesktopItems
      oldest-supported-numpy
      cython
      qt5.wrapQtAppsHook
      recommonmark
      setuptools
      sphinx
      wheel
    ];

    enableParallelBuilding = true;

    pythonRelaxDeps = [ "scikit-learn" ];

    propagatedBuildInputs = [
      numpy
      scipy
      chardet
      catboost
      xgboost
      openpyxl
      opentsne
      qtconsole
      setuptools
      bottleneck
      matplotlib
      joblib
      requests
      keyring
      scikit-learn
      pandas
      pyqtwebengine
      serverfiles
      orange-canvas-core
      python-louvain
      xlrd
      xlsxwriter
      httpx
      pyqtgraph
      orange-widget-base
      keyrings-alt
      pyyaml
      baycomp
      pip
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
      updateScript = nix-update-script { };
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
            --replace test_learners mk_test_learners

          substituteInPlace Orange/modelling/tests/test_xgb.py \
            --replace test_learners mk_test_learners

          substituteInPlace Orange/**/tests/*.py \
            --replace test_filename filename_test

          # TODO: debug why orange is crashing on GC, may be a upstream issue
          chmod +x Orange/__init__.py
          echo "import gc; gc.disable()" | tee -a Orange/__init__.py

        '';

        nativeBuildInputs = [
          pytestCheckHook
          pytest-qt
        ];

        postCheck = ''
          touch $out
        '';

        doBuild = false;
        doInstall = false;

        buildInputs = [ self ];
      };
    };

    meta = with lib; {
      description = "Data mining and visualization toolbox for novice and expert alike";
      homepage = "https://orangedatamining.com/";
      changelog = "https://github.com/biolab/orange3/blob/${version}/CHANGELOG.md";
      license = with licenses; [ gpl3Plus ];
      maintainers = with maintainers; [ lucasew ];
      mainProgram = "orange-canvas";
    };
  };
in
self
