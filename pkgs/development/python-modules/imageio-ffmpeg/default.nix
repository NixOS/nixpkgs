{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, substituteAll
, ffmpeg
, python
}:

buildPythonPackage rec {
  pname = "imageio-ffmpeg";
  version = "0.4.5";

  disabled = !isPy3k;

  src = fetchFromGitHub {
     owner = "imageio";
     repo = "imageio-ffmpeg";
     rev = "v0.4.5";
     sha256 = "1srwfnh964nh6r7z0k6s7rb61phzrdb25kgjvksq23hn1rxv6kf0";
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
