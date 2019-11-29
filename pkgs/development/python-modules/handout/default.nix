{ stdenv, buildPythonPackage, fetchPypi
, imageio, imageio-ffmpeg }:

buildPythonPackage rec {
  pname = "handout";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dbe5da9b422fa937b94a1a5221ce99387ebd75fe97ab4255e49b26d846b8614b";
  };

  propagatedBuildInputs = [ imageio imageio-ffmpeg ];

  meta = with stdenv.lib; {
    description = "Turn Python scripts into handouts with Markdown and figures";
    homepage = "https://github.com/danijar/handout";
    license = licenses.gpl3;
    maintainers = with maintainers; [ averelld ];
  };
}
