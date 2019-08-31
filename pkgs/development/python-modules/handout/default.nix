{ stdenv, buildPythonPackage, fetchPypi
, imageio, imageio-ffmpeg }:

buildPythonPackage rec {
  pname = "handout";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16y1wqx8j4kf6fa94x22njrkdfb2cfi0dvc7a4q2qsa8m3ri0b43";
  };

  propagatedBuildInputs = [ imageio imageio-ffmpeg ];

  meta = with stdenv.lib; {
    description = "Turn Python scripts into handouts with Markdown and figures";
    homepage = "https://github.com/danijar/handout";
    license = licenses.gpl3;
    maintainers = with maintainers; [ averelld ];
  };
}
