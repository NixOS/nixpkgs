{ stdenvNoCC
, lib
, fetchFromGitLab
, gitUpdater
, gtk3
, hicolor-icon-theme
, ubuntu-themes
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "suru-icon-theme";
  version = "2024.02.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/suru-icon-theme";
    rev = finalAttrs.version;
    hash = "sha256-7T9FILhZrs5bbdBEV/FszCOwUd/C1Rl9tbDt77SIzRk=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gtk3 # gtk-update-icon-cache
    hicolor-icon-theme # theme setup hook
  ];

  propagatedBuildInputs = [
    ubuntu-themes
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r suru $out/share/icons/

    gtk-update-icon-cache $out/share/icons/suru

    runHook postInstall
  '';

  dontDropIconThemeCache = true;

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Suru Icon Theme for Lomiri Operating Environment";
    homepage = "https://gitlab.com/ubports/development/core/suru-icon-theme";
    changelog = "https://gitlab.com/ubports/development/core/suru-icon-theme/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.cc-by-sa-30;
    maintainers = teams.lomiri.members;
    platforms = platforms.all;
  };
})
