{
  lib,
  fetchFromGitHub,
  tcl,
  tcllib,
}:

tcl.mkTclDerivation rec {
  pname = "critcl";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "andreas-kupries";
    repo = "critcl";
    rev = version;
    hash = "sha256-IxScn9ZTlqD9mG9VJLG+TtplLFhhahOiFhQCjxp22Uk=";
  };

  buildInputs = [
    tcl
    tcllib
  ];

  dontBuild = true;
  doCheck = true;

  checkPhase = ''
    runHook preInstall
    HOME="$(mktemp -d)" tclsh ./build.tcl test
    runHook postInstall
  '';

  installPhase = ''
    runHook preInstall
    tclsh ./build.tcl install --prefix $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "Easily embed C code in Tcl";
    homepage = "https://andreas-kupries.github.io/critcl/";
    license = licenses.tcltk;
    mainProgram = "critcl";
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
