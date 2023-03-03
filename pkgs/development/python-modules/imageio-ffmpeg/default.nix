{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, substituteAll
, ffmpeg_4
, python
}:

buildPythonPackage rec {
  pname = "imageio-ffmpeg";
  version = "0.4.8";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/aoFrRD+Bwt/qOX2FcsNKPO5t5HQCvbSoR5pQVjRCqk=";
  };

  patches = [
    (substituteAll {
      src = ./ffmpeg-path.patch;
      ffmpeg = "${ffmpeg_4}/bin/ffmpeg";
    })
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} << EOF
    from imageio_ffmpeg import get_ffmpeg_version
    assert get_ffmpeg_version() == '${ffmpeg_4.version}'
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
