{
  lib,
  buildPythonPackage,
  cairosvg,
  fetchFromGitHub,
  imageio-ffmpeg,
  imageio,
  numpy,
  pwkit,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "drawsvg";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cduck";
    repo = "drawsvg";
    tag = finalAttrs.version;
    hash = "sha256-JC7u6bEB7RCJVLeYnNqACmddLI5F5PyaaBxaAZ+N/5s=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    all = [
      cairosvg
      imageio
      imageio-ffmpeg
      numpy
      pwkit
    ];
    raster = [
      cairosvg
      imageio
      imageio-ffmpeg
      numpy
    ];
    color = [
      numpy
      pwkit
    ];
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "drawsvg" ];

  meta = {
    description = "Programmatically generate SVG (vector) images, animations, and interactive Jupyter widgets";
    homepage = "https://github.com/cduck/drawsvg";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
