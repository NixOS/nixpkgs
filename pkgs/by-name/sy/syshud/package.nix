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
  version = "0-unstable-2024-06-20";

  src = fetchFromGitHub {
    owner = "System64fumo";
    repo = "syshud";
    rev = "2b97f3441970efe67c788a8313eb58182aa7965b";
    hash = "sha256-XPAKjBLaTGEyDgiZT8tYinYzMivOocOEeauzR4leOjI=";
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
