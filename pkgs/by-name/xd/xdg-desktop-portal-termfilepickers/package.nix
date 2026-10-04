{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nushell,
  yazi,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xdg-desktop-portal-termfilepickers";
  version = "1.0.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Guekka";
    repo = "xdg-desktop-portal-termfilepickers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bo9zZzzAq+0mJEby1lW6c4/QEp5KwfOFncBJYj/AqCY=";
  };

  cargoHash = "sha256-RHBXifAMB5Rqk0UXOMtGd71DLcAGRUW7w1ADZw748Q4=";

  # for patchShebangs on the nushell wrapper scripts
  buildInputs = [ nushell ];

  postPatch = ''
    substituteInPlace data/share/wrappers/yazi-{open,save}-file.nu \
      --replace-fail '"yazi"' '"${lib.getExe yazi}"'
  '';

  postInstall = ''
    cp -r data/share $out/share
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "xdg-desktop-portal FileChooser backend for picking files with a terminal file manager";
    homepage = "https://github.com/Guekka/xdg-desktop-portal-termfilepickers";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ anish ];
    mainProgram = "xdg-desktop-portal-termfilepickers";
    platforms = lib.platforms.linux;
  };
})
