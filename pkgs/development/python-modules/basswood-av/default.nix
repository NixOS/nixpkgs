{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pkg-config,
  cython_3_1,
  ffmpeg,
}:

buildPythonPackage rec {
  pname = "basswood-av";
  version = "15.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "basswood-io";
    repo = "BasswoodAV";
    tag = version;
    hash = "sha256-GWNMPiNk8nSSm45EaRm1Te0PpCNPSYf62WbPYFY/9H8=";
  };

  build-system = [
    setuptools
    cython_3_1
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ffmpeg ];

  pythonImportsCheck = [ "bv" ];

  meta = {
    description = "Python bindings for ffmpeg libraries";
    homepage = "https://github.com/basswood-io/BasswoodAV";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
