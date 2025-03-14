{
  lib,
  stdenv,
  fetchFromGitHub,
  libcoldclear,
  luajit,
}:

stdenv.mkDerivation rec {
  pname = "ccloader";
  version = "11.4.2";

  src = fetchFromGitHub {
    owner = "26F-Studio";
    repo = "cold_clear_ai_love2d_wrapper";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-sguV+Dw+etZH43tXZYL46NAdsI/qvyvGWCPUiTEjhy4=";
  };

  buildInputs = [
    libcoldclear
    luajit
  ];

  buildPhase = ''
    runHook preBuild

    gcc -shared cold_clear_wrapper.c -lcold_clear -lluajit-${luajit.luaversion} -o CCLoader.so

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/lua/${luajit.luaversion}
    mv CCLoader.so $out/lib/lua/${luajit.luaversion}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Luajit wrapper for Cold Clear, a Tetris AI";
    homepage = "https://github.com/26F-Studio/cold_clear_ai_love2d_wrapper";
    license = licenses.mpl20;
    maintainers = with maintainers; [ chayleaf ];
  };
}
