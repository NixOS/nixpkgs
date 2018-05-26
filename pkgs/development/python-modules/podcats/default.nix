{ lib, buildPythonPackage, fetchFromGitHub, flask, mutagen }:

buildPythonPackage rec {
  pname = "podcats";
  version = "v0.5.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "jakubroztocil";
    repo = "podcats";
    rev = version;
    sha256 = "0zjdgry5n209rv19kj9yaxy7c7zq5gxr488izrgs4sc75vdzz8xc";
  };

  patchPhase = ''
    substituteInPlace podcats.py \
      --replace 'debug=True' 'debug=True, use_reloader=False'
  '';

  propagatedBuildInputs = [ flask mutagen ];

  meta = {
    description = "Application that generates RSS feeds for podcast episodes from local audio files";
    homepage = https://github.com/jakubroztocil/podcats;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ the-kenny ];
  };
}
