{
  lib,
  stdenv,
  fetchFromGitHub,
  glibmm,
  gtk4-layer-shell,
  gtkmm4,
  libevdev,
  nix-update-script,
  pkg-config,
  wireplumber,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "syshud";
  version = "0-unstable-2025-03-11";

  src = fetchFromGitHub {
    owner = "System64fumo";
    repo = "syshud";
    rev = "6a90edad20437a1d933937a44a4e3553caeb248f";
    hash = "sha256-Lmv75OaPOK+NxDe+7Xgf/NDvyms+zXn8tYThQJRxf9k=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail pkg-config ''${PKG_CONFIG}
    substituteInPlace src/main.cpp \
      --replace-fail /usr/share/sys64/hud/config.conf $out/share/sys64/hud/config.conf
    substituteInPlace src/window.cpp \
      --replace-fail /usr/share/sys64/hud/style.css $out/share/sys64/hud/style.css
  '';

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glibmm
    gtk4-layer-shell
    gtkmm4
    libevdev
    wireplumber
  ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  # populate version info used by `syshud -v`:
  configurePhase = ''
    runHook preConfigure

    echo '#define GIT_COMMIT_MESSAGE "${finalAttrs.src.rev}"' >> src/git_info.hpp
    echo '#define GIT_COMMIT_DATE "${lib.removePrefix "0-unstable-" finalAttrs.version}"' >> src/git_info.hpp

    runHook postConfigure
  '';

  # syshud manually `dlopen`'s its library component
  postInstall = ''
    wrapProgram $out/bin/syshud --prefix LD_LIBRARY_PATH : $out/lib
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "simple heads up display written in gtkmm 4";
    mainProgram = "syshud";
    homepage = "https://github.com/System64fumo/syshud";
    license = lib.licenses.wtfpl;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ colinsane ];
  };
})
