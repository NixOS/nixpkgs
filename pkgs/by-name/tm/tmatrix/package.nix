{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  installShellFiles,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tmatrix";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "M4444";
    repo = "TMatrix";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-G3dg0SWfBjCA66TTxkVAcVrFNJOWE9+GJXYKzCUX34w=";
  };

  nativeBuildInputs = [
    cmake
    installShellFiles
  ];
  buildInputs = [ ncurses ];

  postInstall = ''
    installManPage ../tmatrix.6
  '';

  meta = {
    description = "Terminal based replica of the digital rain from The Matrix";
    longDescription = ''
      TMatrix is a program that simulates the digital rain form The Matrix.
      It's focused on being the most accurate replica of the digital rain effect
      achievable on a typical terminal, while also being customizable and
      performant.
    '';
    homepage = "https://github.com/M4444/TMatrix";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    mainProgram = "tmatrix";
  };
})
