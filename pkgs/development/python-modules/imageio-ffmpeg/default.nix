{
  lib,
  buildPythonPackage,
  fetchPypi,
  substituteAll,
  ffmpeg_4,
  python,
}:

buildPythonPackage rec {
  pname = "imageio-ffmpeg";
  version = "0.4.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ObzRZgEY7zYPpAR0VlAQcTZGYaqdkCHT0mxY8e4ggfU=";
  };

  patches = [
    (substituteAll {
      src = ./ffmpeg-path.patch;
      ffmpeg = "${ffmpeg_4}/bin/ffmpeg";
    })
  ];

  # https://github.com/imageio/imageio-ffmpeg/issues/59
  postPatch = ''
    sed -i '/setup_requires=\["pip>19"\]/d' setup.py
  '';

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
