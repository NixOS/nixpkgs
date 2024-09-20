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
    sha256 = "52daaf1f9a4cb2ceb88c1dedf85d22ef449b9422b424a2534d21f941e57bc915";
  };

  propagatedBuildInputs = [
    imageio
    imageio-ffmpeg
  ];

  meta = with lib; {
    description = "Turn Python scripts into handouts with Markdown and figures";
    homepage = "https://github.com/danijar/handout";
    license = licenses.gpl3;
    maintainers = with maintainers; [ averelld ];
  };
}
