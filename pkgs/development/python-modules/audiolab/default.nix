{
  lib,
  buildPythonPackage,
  fetchPypi,
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

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-+ejaQnhN/UBZW9T72iStlqfgfSYc9MqsdNFbsWEpO6Y=";
  };

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

  meta = {
    description = "Python library for audio processing built on top of SoundFile and PyAV";
    homepage = "https://github.com/pengzhendong/audiolab";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Tenshock ];
  };
})
