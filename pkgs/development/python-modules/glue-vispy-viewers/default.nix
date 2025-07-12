{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  glue-core,
  matplotlib,
  numpy,
  pytestCheckHook,
  echo,
  scipy,
  glfw,
  imageio,
  vispy,
  pyopengl,
  pytest-cov,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "glue-vispy-viewers";
  version = "1.2.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "glue-viz";
    repo = "glue-vispy-viewers";
    tag = "v${version}";
    hash = "sha256-rmfi0hyNhpI0mYCFX2AYboSGGbe70a9KBonlyMK6EIM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    glue-core
    echo
    matplotlib
    glfw
    imageio
    vispy
    numpy
    setuptools
    scipy
    pyopengl
  ];

  dontConfigure = true;

  # collecting ... qt.qpa.xcb: could not connect to display
  # qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "" even though it was found.
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [ "glue_vispy_viewers" ];

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    homepage = "https://glueviz.org";
    description = "Vispy-based viewers for Glue";
    license = licenses.bsd2; # https://github.com/glue-viz/glue-vispy-viewers/blob/main/LICENSE
    maintainers = with maintainers; [ ifurther ];
  };
}
