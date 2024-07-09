{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk4-layer-shell,
  gtkmm4,
  nix-update-script,
  pkg-config,
  wireplumber,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "syshud";
  version = "0-unstable-2024-07-01";

  src = fetchFromGitHub {
    owner = "System64fumo";
    repo = "syshud";
    rev = "cfe4a3a898c7f7b2e7065095c7fdcc33d99ed4bf";
    hash = "sha256-UrAKFehcqsuFHJJC0Ske+tOr6Wquqm/BM536hKoGEWw=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'pkg-config' ''${PKG_CONFIG}
  '';

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4-layer-shell
    gtkmm4
    wireplumber
  ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
  ];

  # populate version info used by `syshud -v`:
  configurePhase = ''
    runHook preConfigure

    echo '#define GIT_COMMIT_MESSAGE "${finalAttrs.src.rev}"' >> src/git_info.hpp
    echo '#define GIT_COMMIT_DATE "${lib.removePrefix "0-unstable-" finalAttrs.version}"' >> src/git_info.hpp

    runHook postConfigure
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version" "branch" ];
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
