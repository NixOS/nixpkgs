{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libxcb,
}:

stdenv.mkDerivation rec {
  pname = "xkbmon";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "xkbmon";
    repo = "xkbmon";
    rev = version;
    sha256 = "sha256-EWW6L6NojzXodDOET01LMcQT8/1JIMpOD++MCiM3j1Y=";
  };

  buildInputs = [
    libX11
    libxcb
  ];

  installPhase = "install -D -t $out/bin xkbmon";

  meta = with lib; {
    homepage = "https://github.com/xkbmon/xkbmon";
    description = "Command-line keyboard layout monitor for X11";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
    mainProgram = "xkbmon";
  };
}
