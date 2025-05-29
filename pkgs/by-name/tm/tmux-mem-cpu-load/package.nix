{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "tmux-mem-cpu-load";
  version = "3.8.2";

  src = fetchFromGitHub {
    owner = "thewtex";
    repo = "tmux-mem-cpu-load";
    rev = "v${version}";
    sha256 = "sha256-g++6n6OD9FAw8CtXArKBgNwFf+3v+SBCHmbma7RpMBA=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "CPU, RAM, and load monitor for use with tmux";
    homepage = "https://github.com/thewtex/tmux-mem-cpu-load";
    license = licenses.asl20;
    maintainers = with maintainers; [ thomasjm ];
    platforms = platforms.all;
    mainProgram = "tmux-mem-cpu-load";
  };
}
