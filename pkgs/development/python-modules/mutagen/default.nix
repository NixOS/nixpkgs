{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # docs
  sphinxHook,
  sphinx-rtd-theme,

  # tests
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mutagen";
  version = "1.48.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "quodlibet";
    repo = "mutagen";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-CasNC5oW59WOUr7WSu4lUnYYzs6ow8RuJAylqNW7geA=";
  };

  outputs = [
    "out"
    "doc"
  ];

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-rtd-theme
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mutagen" ];

  meta = {
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
    changelog = "https://mutagen.readthedocs.io/en/latest/changelog.html#release-${
      lib.replaceString "." "-" finalAttrs.version
    }";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
