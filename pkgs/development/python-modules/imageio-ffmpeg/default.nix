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
  version = "0.4.3";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f826260a3207b872f1a4ba87ec0c8e02c00afba4fd03348a59049bdd8215841e";
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
