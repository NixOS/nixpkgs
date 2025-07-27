{
  lib,
  stdenv,
  fetchFromGitHub,
  zsh,
}:

stdenv.mkDerivation {
  pname = "zthrottle";
  version = "0-unstable-2017-07-24";

  src = fetchFromGitHub {
    owner = "anko";
    repo = "zthrottle";
    rev = "f62066661e49375baeb891fa8e43ad4527cbd0a0";
    sha256 = "1ipvwmcsigzmxlg7j22cxpvdcgqckkmfpsnvzy18nbybd5ars9l5";
  };

  buildInputs = [ zsh ];

  installPhase = ''
    install -D zthrottle $out/bin/zthrottle
  '';

  meta = with lib; {
    description = "Program that throttles a pipeline, only letting a line through at most every $1 seconds";
    homepage = "https://github.com/anko/zthrottle";
    license = licenses.unlicense;
    maintainers = [ ];
    platforms = platforms.unix;
    mainProgram = "zthrottle";
  };
}
