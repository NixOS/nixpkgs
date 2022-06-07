{ lib
, buildPythonPackage
, fetchFromGitHub
, pygame
, numpy
}:

buildPythonPackage rec {
  pname = "pgzero";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "lordmauve";
    repo = "pgzero";
    rev = version;
    sha256 = "O3fQCs8lwyF42N2vmlJvkk/UqsNS3T4geDiHZj9lS3M=";
  };

  postPatch= ''
    rm test/test_screen.py test/test_actor.py test/test_sound_formats.py
  '';

  propagatedBuildInputs = [ numpy pygame ];

  meta = with lib; {
    description = "A zero-boilerplate games programming framework for Python 3, based on Pygame.";
    homepage = "https://github.com/lordmauve/pgzero";
    license = with licenses; [ lgpl3 ];
    maintainers = with maintainers; [ malbarbo ];
  };
}
