{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libxcb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xkbmon";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "xkbmon";
    repo = "xkbmon";
    rev = finalAttrs.version;
    sha256 = "sha256-EWW6L6NojzXodDOET01LMcQT8/1JIMpOD++MCiM3j1Y=";
  };

  buildInputs = [
    libX11
    libxcb
  ];

  installPhase = "install -D -t $out/bin xkbmon";

  meta = {
    homepage = "https://github.com/xkbmon/xkbmon";
    description = "Command-line keyboard layout monitor for X11";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
    mainProgram = "xkbmon";
  };
})
