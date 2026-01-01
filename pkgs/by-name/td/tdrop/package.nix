{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  xwininfo,
  xdotool,
  xprop,
  gawk,
  coreutils,
  gnugrep,
  procps,
}:

stdenv.mkDerivation rec {
  pname = "tdrop";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "noctuid";
    repo = "tdrop";
    rev = version;
    sha256 = "sha256-fHvGXaZL7MMvTnkap341B79PDDo2lOVPPcOH4AX/zXo=";
  };

  dontBuild = true;

  installFlags = [ "PREFIX=$(out)" ];

  postInstall =
    let
      binPath = lib.makeBinPath [
        xwininfo
        xdotool
        xprop
        gawk
        coreutils
        gnugrep
        procps
      ];
    in
    ''
      wrapProgram $out/bin/tdrop --prefix PATH : ${binPath}
    '';

  nativeBuildInputs = [ makeWrapper ];

<<<<<<< HEAD
  meta = {
    description = "Glorified WM-Independent Dropdown Creator";
    mainProgram = "tdrop";
    homepage = "https://github.com/noctuid/tdrop";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Glorified WM-Independent Dropdown Creator";
    mainProgram = "tdrop";
    homepage = "https://github.com/noctuid/tdrop";
    license = licenses.bsd2;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
