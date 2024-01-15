{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi

# build-system
, setuptools

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
  version = "1.47.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cZ+t7wqXjDG0zzyVYmGzxYtpSLMgIweKIRex3gnw/Jk=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    setuptools
    sphinx
    sphinx-rtd-theme
  ];

  postInstall = ''
    ${python.pythonOnBuildForHost.interpreter} setup.py build_sphinx --build-dir=$doc
  '';

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  disabledTests = [
    # Hypothesis produces unreliable results: Falsified on the first call but did not on a subsequent one
    "test_test_fileobj_save"
    "test_test_fileobj_load"
    "test_test_fileobj_delete"
    "test_mock_fileobj"
  ];

  pythonImportsCheck = [
    "mutagen"
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
    maintainers = with maintainers; [ ];
  };
}
