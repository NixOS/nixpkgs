{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi

# docs
, python
, sphinx
, sphinx-rtd-theme

# tests
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mutagen";
  version = "1.45.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6397602efb3c2d7baebd2166ed85731ae1c1d475abca22090b7141ff5034b3e1";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [
    sphinx
    sphinx-rtd-theme
  ];

  postInstall = ''
    ${python.pythonForBuild.interpreter} setup.py build_sphinx --build-dir=$doc
  '';

  checkInputs = [
    hypothesis
    pytestCheckHook
  ];

  disabledTests = [
    # Hypothesis produces unreliable results: Falsified on the first call but did not on a subsequent one
    "test_test_fileobj_save"
  ];

  disabledTestPaths = [
    # we are not interested in code quality measurements
    "tests/quality/test_flake8.py"
  ];

  meta = with lib; {
    description = "Python module for handling audio metadata";
    longDescription = ''
      Mutagen is a Python module to handle audio metadata. It supports
      ASF, FLAC, MP4, Monkey's Audio, MP3, Musepack, Ogg Opus, Ogg FLAC,
      Ogg Speex, Ogg Theora, Ogg Vorbis, True Audio, WavPack, OptimFROG,
      and AIFF audio files. All versions of ID3v2 are supported, and all
      standard ID3v2.4 frames are parsed. It can read Xing headers to
      accurately calculate the bitrate and length of MP3s. ID3 and APEv2
      tags can be edited regardless of audio format. It can also
      manipulate Ogg streams on an individual packet/page level.
    '';
    homepage = "https://mutagen.readthedocs.io";
    changelog = "https://mutagen.readthedocs.io/en/latest/changelog.html#release-${lib.replaceStrings [ "." ] [ "-" ] version}";
    license = licenses.gpl2Plus;
  };
}
