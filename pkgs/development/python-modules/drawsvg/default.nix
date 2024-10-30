{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  numpy,
  imageio,
  cairosvg,
  imageio-ffmpeg,
  pwkit,
}:

buildPythonPackage rec {
  pname = "drawsvg";
  version = "2.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "cduck";
    repo = "drawsvg";
    rev = "refs/tags/${version}";
    hash = "sha256-JC7u6bEB7RCJVLeYnNqACmddLI5F5PyaaBxaAZ+N/5s=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    all = [
      numpy
      imageio
      cairosvg
      imageio-ffmpeg
      pwkit
    ];
    raster = [
      numpy
      imageio
      cairosvg
      imageio-ffmpeg
    ];
    color = [
      pwkit
      numpy
    ];
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "drawsvg" ];

  meta = with lib; {
    description = "Programmatically generate SVG (vector) images, animations, and interactive Jupyter widgets";
    homepage = "https://github.com/cduck/drawsvg";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
