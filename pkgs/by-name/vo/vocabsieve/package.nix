{ lib
, python3
, fetchFromGitHub

, gst_all_1
, qt5
}:

python3.pkgs.buildPythonApplication rec {
  pname = "vocabsieve";
  version = "0.11.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "FreeLanguageTools";
    repo = "vocabsieve";
    rev = "v${version}";
    hash = "sha256-7POxaMo37brZes1dz/bteGYN9MIkhVPiRIDMBPxw39A=";
  };

  nativeBuildInputs = [
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-vaapi
    gst_all_1.gstreamer
    python3.pkgs.setuptools
    qt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    bidict
    ebooklib
    flask
    flask-sqlalchemy
    lxml
    markdown
    markdownify
    mobi
    packaging
    pymorphy3
    pyqtdarktheme
    (pyqtgraph.override { pyqt5 = pyqt5_with_qtmultimedia; })
    pystardict
    pysubs2
    readmdict
    requests
    sentence-splitter
    simplemma
    slpp
    typing-extensions
  ];

  postFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    makeWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = with lib; {
    description = "Simple sentence mining tool for language learning";
    homepage = "https://github.com/FreeLanguageTools/vocabsieve";
    license = licenses.gpl3Plus;
    mainProgram = "vocabsieve";
    maintainers = with maintainers; [ paveloom ];
  };
}
