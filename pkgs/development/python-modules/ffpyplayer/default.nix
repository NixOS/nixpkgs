{ lib
, buildPythonPackage
, fetchFromGitHub
, pkg-config
, SDL2
, ffmpeg-full
, cython
, pytest
}:

buildPythonPackage rec {
  pname = "ffpyplayer";
  version = "4.5.1";
  format = "setuptools";
  src = fetchFromGitHub {
    owner = "matham";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-hVZBcM03EqO93FtaQQIkwj6EgD9cQy51EdEnR6mpd6A=";
  };

  nativeBuildInputs = [
    pkg-config
    cython
    pytest
  ];
  buildInputs = [
    SDL2
    ffmpeg-full
  ];

  meta = with lib; {
    homepage = "https://matham.github.io/ffpyplayer";
    description = "A cython implementation of an ffmpeg based player";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ annaaurora ];
  };
}
