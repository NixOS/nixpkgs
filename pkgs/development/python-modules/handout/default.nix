{
  lib,
  buildPythonPackage,
  fetchPypi,
  imageio,
  imageio-ffmpeg,
}:

buildPythonPackage rec {
  pname = "handout";
  version = "1.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UtqvH5pMss64jB3t+F0i70SblCK0JKJTTSH5QeV7yRU=";
  };

  propagatedBuildInputs = [
    imageio
    imageio-ffmpeg
  ];

  meta = {
    description = "Turn Python scripts into handouts with Markdown and figures";
    homepage = "https://github.com/danijar/handout";
    license = lib.licenses.gpl3;
    maintainers = [ ];
  };
}
