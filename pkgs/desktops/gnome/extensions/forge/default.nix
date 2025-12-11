{
  fetchFromGitHub,
  glib,
  lib,
  stdenv,
  ...
}:
let
  uuid = "forge@jmmaranan.com";
in
stdenv.mkDerivation {
  pname = "gnome-shell-extension-forge";
  version = "49.2-development";

  src = fetchFromGitHub {
    owner = "forge-ext";
    repo = "forge";
    rev = "701e7587e88fd51cc10e0f2fc5124ac61c82cf1c";
    hash = "sha256-yKBH4Hv4b0CUVubsfs8a8fg3nIuogvGp5DJT/HjBcns=";
  };

  nativeBuildInputs = [ glib ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas --strict schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/
    cp -r -T . $out/share/gnome-shell/extensions/${uuid}
    # The makefile autogenerates a lib/prefs/metadata.js with a list of
    # developers. We can just hardcode an empty one to avoid having to read the
    # git history during the derivation.
    echo "export const developers = []" > \
      $out/share/gnome-shell/extensions/${uuid}/lib/prefs/metadata.js
    runHook postInstall
  '';

  passthru = {
    extensionPortalSlug = "forge";
    extensionUuid = uuid;
  };

  meta = {
    description = "Tiling and window manager for GNOME";
    homepage = "https://extensions.gnome.org/extension/4481/forge/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ agustinmista ];
    platforms = lib.platforms.linux;
  };
}
