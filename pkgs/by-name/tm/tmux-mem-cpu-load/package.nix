{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "tmux-mem-cpu-load";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "thewtex";
    repo = "tmux-mem-cpu-load";
    rev = "v${version}";
    sha256 = "sha256-8QUcEbgk3DSsWt9TRHHtDhQ7a1hkK8RZEX+0d3h/c0w=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "CPU, RAM, and load monitor for use with tmux";
    homepage = "https://github.com/thewtex/tmux-mem-cpu-load";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thomasjm ];
    platforms = lib.platforms.all;
    mainProgram = "tmux-mem-cpu-load";
  };
}
