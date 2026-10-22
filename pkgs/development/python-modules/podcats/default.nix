{
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  humanize,
  lib,
  mutagen,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "podcats";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jkbrzt";
    repo = "podcats";
    tag = finalAttrs.version;
    hash = "sha256-1Jg9bR/3qMim3q5qVwUVbxeLNaXaCU6SplBUaRXeLpo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    humanize
    mutagen
  ];

  pythonImportsCheck = [ "podcats" ];
  doCheck = false;

  meta = {
    description = "Generates RSS feeds for podcast episodes from local audio files";
    mainProgram = "podcats";
    homepage = "https://github.com/jkbrzt/podcats";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ drawbu ];
  };
})
