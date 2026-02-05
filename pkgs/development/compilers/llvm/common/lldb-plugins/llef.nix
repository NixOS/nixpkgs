{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  lldb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "llef";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "foundryzero";
    repo = "llef";
    rev = "v${finalAttrs.version}";
    hash = "sha256-w1Chaq/rGv1amvpJqiyKFxK0dQdsyplgFmBKj/Xmtqg=";
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

  meta = {
    description = "LLEF is a plugin for LLDB to make it more useful for RE and VR";
    homepage = "https://github.com/foundryzero/llef";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ nrabulinski ];
    mainProgram = "llef";
  };
})
