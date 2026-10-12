{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  qt6,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "vault-launcher";
  version = "0.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "manihindrich";
    repo = "VaultLauncher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-voc1tvSuyY39QHYCROKE9dDicoSMtmTpTD0HY7FW4BY=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies = [ python3Packages.pyside6 ];

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
  ];

  # Wrap the Python entry point with the Qt environment instead of a second wrapper.
  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  postInstall = ''
    install -Dm644 data/io.github.manihindrich.VaultLauncher.desktop -t $out/share/applications
    # Use Obsidian's own icon, which the Obsidian package provides.
    substituteInPlace $out/share/applications/io.github.manihindrich.VaultLauncher.desktop \
      --replace-fail "Icon=io.github.manihindrich.VaultLauncher" "Icon=obsidian"
    install -Dm644 data/io.github.manihindrich.VaultLauncher.metainfo.xml -t $out/share/metainfo
    install -Dm644 src/vault_launcher/resources/app-icon.svg \
      $out/share/icons/hicolor/scalable/apps/io.github.manihindrich.VaultLauncher.svg
  '';

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  pythonImportsCheck = [ "vault_launcher" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Small window to pick an Obsidian vault and open it";
    homepage = "https://github.com/manihindrich/VaultLauncher";
    changelog = "https://github.com/manihindrich/VaultLauncher/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ manihindrich ];
    mainProgram = "vault-launcher";
    platforms = lib.platforms.linux;
  };
})
