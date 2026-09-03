{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  # build-system
  setuptools,

  # dependencies
  colormath,
  ipython,
  kivy,
  matplotlib,
  numpy,
  pillow,
  plotly,
  pygame,
}:

buildPythonPackage (finalAttrs: {
  pname = "colorir";
  version = "2.1.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aleferna12";
    repo = "colorir";
    rev = "34d45e10ca2b575ac2fdcdadc53beed1ffd693c7";
    hash = "sha256-mlsbcLYUl7iiCz33rTmMfld3LDZzBWM2mSIM9M18hDM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    colormath
    ipython
    kivy
    matplotlib
    numpy
    pillow
    plotly
    pygame
  ];

  pythonImportsCheck = [
    "colorir"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A python package for creation and management of color palettes";
    homepage = "https://github.com/aleferna12/colorir";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dccabanas ];
    mainProgram = "colorir";
  };
})
