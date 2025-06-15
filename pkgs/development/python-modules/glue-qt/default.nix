{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  astropy,
  copyDesktopItems,
  makeDesktopItem,
  echo,
  glue-core,
  ipython,
  ipykernel,
  matplotlib,
  numpy,
  pyqt-builder,
  pytestCheckHook,
  pytest-cov,
  pvextractor,
  libsForQt5,
  qtconsole,
  scipy,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "glue-qt";
  version = "0.3.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "glue-viz";
    repo = "glue-qt";
    tag = "v${version}";
    hash = "sha256-Er/fvE7YKtJfahGt9TRFjY3TqURy+XLoOuXLf7/uH5M=";
  };

  buildInputs = [ pyqt-builder ];

  nativeBuildInputs = [ copyDesktopItems ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    astropy
    glue-core
    echo
    ipython
    ipykernel
    matplotlib
    numpy
    pvextractor
    setuptools
    scipy
    qtconsole
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Glueviz";
      categories = [
        "Education"
        "Science"
      ];
      exec = "glue";
      icon = "glueviz";
      comment = meta.description;
      desktopName = "Glueviz";
    })
  ];

  postInstall = ''
    install -Dm644 $src/glueviz.png $out/share/pixmaps/glueviz.png
  '';

  dontConfigure = true;

  # collecting ... qt.qpa.xcb: could not connect to display
  # qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "" even though it was found.
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [ "glue_qt" ];

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    homepage = "https://glueviz.org";
    description = "Multidimensional data visualization across files";
    license = licenses.bsd3; # https://github.com/glue-viz/glue-qt/blob/main/LICENSE
    maintainers = with maintainers; [ ifurther ];
  };
}
