{
  lib,
  stdenv,
  fetchFromGitHub,
  libcoldclear,
  luajit,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ccloader";
  version = "11.4.2";

  src = fetchFromGitHub {
    owner = "26F-Studio";
    repo = "cold_clear_ai_love2d_wrapper";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-sguV+Dw+etZH43tXZYL46NAdsI/qvyvGWCPUiTEjhy4=";
  };

  buildInputs = [
    libcoldclear
    luajit
  ];

  buildPhase = ''
    runHook preBuild

    gcc -shared cold_clear_wrapper.c -lcold_clear -lluajit-${luajit.luafinalAttrs.version} -o CCLoader.so

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/lua/${luajit.luafinalAttrs.version}
    mv CCLoader.so $out/lib/lua/${luajit.luafinalAttrs.version}

    runHook postInstall
  '';

  meta = {
    description = "Luajit wrapper for Cold Clear, a Tetris AI";
    homepage = "https://github.com/26F-Studio/cold_clear_ai_love2d_wrapper";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ chayleaf ];
  };
})
