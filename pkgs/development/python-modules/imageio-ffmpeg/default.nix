{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, substituteAll
, ffmpeg
, python
}:

buildPythonPackage rec {
  pname = "imageio-ffmpeg";
  version = "0.4.4";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "73640a7a54f95e607addd637c766d56be31d975a64ddb97d14df012575ef1a5d";
  };

  patches = [
    (substituteAll {
      src = ./ffmpeg-path.patch;
      ffmpeg = "${ffmpeg}/bin/ffmpeg";
    })
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} << EOF
    from imageio_ffmpeg import get_ffmpeg_version
    assert get_ffmpeg_version() == '${ffmpeg.version}'
    EOF

    runHook postCheck
  '';

  pythonImportsCheck = [ "imageio_ffmpeg" ];

  meta = with lib; {
    description = "FFMPEG wrapper for Python";
    homepage = "https://github.com/imageio/imageio-ffmpeg";
    license = licenses.bsd2;
    maintainers = [ maintainers.pmiddend ];
  };

}
