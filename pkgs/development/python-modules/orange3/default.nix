{ lib
, baycomp
, bottleneck
, buildPythonPackage
, chardet
, copyDesktopItems
, cython
, fetchFromGitHub
, fetchurl
, httpx
, joblib
, keyring
, keyrings-alt
, makeDesktopItem
, matplotlib
, nix-update-script
, numpy
, oldest-supported-numpy
, openpyxl
, opentsne
, orange-canvas-core
, orange-widget-base
, pandas
, pyqtgraph
, pyqtwebengine
, python
, python-louvain
, pythonOlder
, pyyaml
, qt5
, qtconsole
, recommonmark
, requests
, scikit-learn
, scipy
, serverfiles
, setuptools
, sphinx
, wheel
, xlrd
, xlsxwriter
}:

let
  self = buildPythonPackage rec {
    pname = "orange3";
    version = "3.36.0";
    format = "pyproject";

    disabled = pythonOlder "3.7";

    src = fetchFromGitHub {
      owner = "biolab";
      repo = "orange3";
      rev = "refs/tags/${version}";
      hash = "sha256-0HIhBdufc46cTOSXa0koelTfZd5sY7QantmwGWggoCU=";
    };

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace "setuptools>=41.0.0,<50.0" "setuptools"
      sed -i 's;\(scikit-learn\)[^$]*;\1;g' requirements-core.txt
      sed -i 's;pyqtgraph[^$]*;;g' requirements-gui.txt # TODO: remove after bump with a version greater than 0.13.1
    '';

    nativeBuildInputs = [
      copyDesktopItems
      cython
      oldest-supported-numpy
      qt5.wrapQtAppsHook
      recommonmark
      setuptools
      sphinx
      wheel
    ];

    enableParallelBuilding = true;

    propagatedBuildInputs = [
      numpy
      scipy
      chardet
      openpyxl
      opentsne
      qtconsole
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
    ];

    # FIXME: ImportError: cannot import name '_variable' from partially initialized module 'Orange.data' (most likely due to a circular import) (/build/source/Orange/data/__init__.py)
    doCheck = false;

    pythonImportsCheck = [ "Orange" "Orange.data._variable" ];

    desktopItems = [
      (makeDesktopItem {
        name = "orange";
        exec = "orange-canvas";
        desktopName = "Orange Data Mining";
        genericName = "Data Mining Suite";
        comment = "Explore, analyze, and visualize your data";
        icon = "orange-canvas";
        mimeTypes = [ "application/x-extension-ows" ];
        categories = [ "Science" "Education" "ArtificialIntelligence" "DataVisualization" "NumericalAnalysis" "Qt" ];
        keywords = [ "Machine Learning" "Scientific Visualization" "Statistical Analysis" ];
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
      tests.unittests = self.overridePythonAttrs (old: {
        pname = "${old.pname}-tests";
        format = "other";

        preCheck = ''
          export HOME=$(mktemp -d)
          export QT_PLUGIN_PATH="${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}"
          export QT_QPA_PLATFORM_PLUGIN_PATH="${qt5.qtbase.bin}/lib/qt-${qt5.qtbase.version}/plugins";
          export QT_QPA_PLATFORM=offscreen

          rm Orange -rf
          cp -r ${self}/${python.sitePackages}/Orange .
          chmod +w -R .

          rm Orange/tests/test_url_reader.py # uses network
          rm Orange/tests/test_ada_boost.py # broken: The 'base_estimator' parameter of AdaBoostRegressor must be an object implementing 'fit' and 'predict' or a str among {'deprecated'}. Got None instead.
        '';

        checkPhase = ''
          runHook preCheck
          ${python.interpreter} -m unittest -b -v ./Orange/**/test*.py
          runHook postCheck
        '';

        postInstall = "";

        doBuild = false;
        doInstall = false;

        nativeBuildInputs = [ self ] ++ old.nativeBuildInputs;
      });
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
