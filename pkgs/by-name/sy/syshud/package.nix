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
  version = "0-unstable-2024-09-26";

  src = fetchFromGitHub {
    owner = "System64fumo";
    repo = "syshud";
    rev = "0b6e4958d8ea66b54bc67f0b5aa005fa3eaa4f6f";
    hash = "sha256-cyE7ZxesAmnepW7kI6b9Gp7R/v+yG2//EQAj4/X6c+c=";
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
