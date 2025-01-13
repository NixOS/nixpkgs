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
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jakubroztocil";
    repo = "podcats";
    rev = "v${version}";
    sha256 = "0zjdgry5n209rv19kj9yaxy7c7zq5gxr488izrgs4sc75vdzz8xc";
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
