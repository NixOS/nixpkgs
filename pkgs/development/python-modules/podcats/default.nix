{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flask,
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

  postPatch = ''
    substituteInPlace podcats.py \
      --replace-fail 'debug=True' 'debug=True, use_reloader=False'
  '';

  build-system = [ setuptools ];

  dependencies = [
    flask
    mutagen
  ];

  meta = {
    description = "Application that generates RSS feeds for podcast episodes from local audio files";
    mainProgram = "podcats";
    homepage = "https://github.com/jakubroztocil/podcats";
    license = lib.licenses.bsd2;
  };
}
