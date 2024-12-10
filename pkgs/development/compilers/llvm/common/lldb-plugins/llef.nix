{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, lldb
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "llef";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "foundryzero";
    repo = "llef";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cpBQuRWpov4q3lEtZPA7ZWqQ8Aa/KKQbhtVStSfNa+Q=";
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
})
