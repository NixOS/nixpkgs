{
  lib,
  stdenv,
  fetchFromGitHub,
  glibmm,
  gtk4-layer-shell,
  gtkmm4,
  wayland-scanner,
  nix-update-script,
  pkg-config,
  wrapGAppsHook4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sysboard";
  version = "0-unstable-2025-11-23";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "System64fumo";
    repo = "sysboard";
    rev = "1a032fb4dd76f3f5496955d293eab2ea90f7fc15";
    hash = "sha256-wSx1YyzZvcuCscSSQi+nrvvIh0iFjLDQgnBXN80KfFU=";
  };

  postPatch = ''
    substituteInPlace src/main.cpp \
      --replace-fail /usr/share/sys64/board/config.conf $out/share/sys64/board/config.conf
    substituteInPlace src/window.cpp \
      --replace-fail /usr/share/sys64/board/style.css $out/share/sys64/board/style.css
  '';

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    wayland-scanner
  ];

  buildInputs = [
    glibmm
    gtk4-layer-shell
    gtkmm4
  ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  # populate version info used by `sysboard -v`:
  configurePhase = ''
    echo '#define GIT_COMMIT_MESSAGE "${finalAttrs.src.rev}"' >> src/git_info.hpp
    echo '#define GIT_COMMIT_DATE "${lib.removePrefix "0-unstable-" finalAttrs.version}"' >> src/git_info.hpp
  '';

  # sysboard manually `dlopen`'s its library component
  postInstall = ''
    patchelf --add-rpath "$out/lib" "$out/bin/sysboard"
  '';

  strictDeps = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Simple virtual keyboard for wayland";
    mainProgram = "sysboard";
    homepage = "https://github.com/System64fumo/sysboard";
    license = lib.licenses.wtfpl;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ yarn ];
  };
})
