{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flask,
  humanize,
  mutagen,
}:

buildPythonPackage rec {
  pname = "podcats";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jakubroztocil";
    repo = "podcats";
    tag = version;
    sha256 = "sha256-1Jg9bR/3qMim3q5qVwUVbxeLNaXaCU6SplBUaRXeLpo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    humanize
    mutagen
  ];

  meta = {
    description = "Application that generates RSS feeds for podcast episodes from local audio files";
    mainProgram = "podcats";
    homepage = "https://github.com/jakubroztocil/podcats";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ drawbu ];
  };
}
