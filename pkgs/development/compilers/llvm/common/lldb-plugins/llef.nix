{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, lldb
}:

stdenv.mkDerivation {
  pname = "llef";
  version = "1.0.0-unstable-2024-05-01";

  src = fetchFromGitHub {
    owner = "foundryzero";
    repo = "llef";
    rev = "f1ebcd4279c697a853cde2f6f0d623bbb4949cd2";
    hash = "sha256-JibvFOSHp6FYIohsF+aO7+SVLIw0F87hLqSFmh53Q5I=";
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
