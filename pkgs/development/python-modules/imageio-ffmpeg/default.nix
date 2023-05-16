{ lib
, buildPythonPackage
<<<<<<< HEAD
=======
, isPy3k
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchPypi
, substituteAll
, ffmpeg_4
, python
}:

buildPythonPackage rec {
  pname = "imageio-ffmpeg";
  version = "0.4.8";
<<<<<<< HEAD
  format = "setuptools";
=======

  disabled = !isPy3k;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
  # https://github.com/imageio/imageio-ffmpeg/issues/59
  postPatch = ''
    sed -i '/setup_requires=\["pip>19"\]/d' setup.py
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
