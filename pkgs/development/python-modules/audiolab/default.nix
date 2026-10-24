{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  av,
  click,
  humanize,
  jinja2,
  requests,
  smart-open,
  soundfile,
  soxr,
}:

buildPythonPackage (finalAttrs: {
  pname = "audiolab";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pengzhendong";
    repo = "audiolab";
    rev = "5b4fc5fd61921c4751c2311e296ee2c09fdc5e19";
    hash = "sha256-EW9XKsHWzgaGxgXPaf1vbiQotwemzt03FBMwW4aWZ38=";
  };

  postPatch = ''
    echo ${finalAttrs.version} > VERSION
  '';

  build-system = [ setuptools ];

  dependencies = [
    av
    click
    humanize
    jinja2
    requests
    smart-open
    soundfile
    soxr
  ];

  pythonImportsCheck = [ "audiolab" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python library for audio processing built on top of SoundFile and PyAV";
    homepage = "https://github.com/pengzhendong/audiolab";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Tenshock ];
  };
})
