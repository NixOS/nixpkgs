{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  lldb,
}:

stdenv.mkDerivation {
  pname = "llef";
  version = "unstable-2023-10-18";

  src = fetchFromGitHub {
    owner = "foundryzero";
    repo = "llef";
    rev = "629bd75f44c356f7a3576a6436d3919ce111240d";
    hash = "sha256-JtCHG89s436Di/6+V7Le4CZnkIPh/RYIllfXEO/B7+8";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/llef
    cp -r llef.py arch commands common handlers $out/share/llef
    makeWrapper ${lib.getExe lldb} $out/bin/llef \
      --add-flags "-o 'settings set stop-disassembly-display never'" \
      --add-flags "-o \"command script import $out/share/llef/llef.py\""

    runHook postInstall
  '';

  meta = with lib; {
    description = "LLEF is a plugin for LLDB to make it more useful for RE and VR";
    homepage = "https://github.com/foundryzero/llef";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ nrabulinski ];
    mainProgram = "llef";
  };
}
