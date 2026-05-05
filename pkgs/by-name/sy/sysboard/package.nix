{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  wayland-scanner,
  gtkmm4,
  gtk4-layer-shell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sysboard";
  version = "9.9.9-unstable-2025-10-23";

  src = fetchFromGitHub {
    owner = "System64fumo";
    repo = "sysboard";
    rev = "1a032fb4dd76f3f5496955d293eab2ea90f7fc15";
    hash = "sha256-wSx1YyzZvcuCscSSQi+nrvvIh0iFjLDQgnBXN80KfFU=";
  };

  # tries to use absolute paths, use relative instead
  # this is referenced from pkg source of syshud
  postPatch = ''
    substituteInPlace src/main.cpp \
      --replace-fail /usr/share/sys64/board/config.conf $out/share/sys64/board/config.conf
    substituteInPlace src/window.cpp \
      --replace-fail /usr/share/sys64/board/style.css $out/share/sys64/board/style.css
  '';

  # make sure we're using the nix paths
  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    makeWrapper
  ];

  buildInputs = [
    gtkmm4
    gtk4-layer-shell
  ];

  # populate version info used by `sysboard -v`:
  configurePhase = ''
    runHook preConfigure

    echo '#define GIT_COMMIT_MESSAGE "${finalAttrs.src.rev}\n"' >> src/git_info.hpp
    echo '#define GIT_COMMIT_DATE "${lib.removePrefix "0-unstable-" finalAttrs.version}"' >> src/git_info.hpp

    runHook postConfigure
  '';

  # sysboard tries to manually `dlopen`'s its library component
  # again, use nix's path
  postFixup = ''
    wrapProgram $out/bin/sysboard --prefix LD_LIBRARY_PATH : $out/lib
  '';

  meta = {
    description = "Simple virtual keyboard for wayland";
    homepage = "https://github.com/System64fumo/sysboard";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      uzlkav
    ];
    mainProgram = "sysboard";
    platforms = lib.platforms.linux;
  };
})
