{
  stdenvNoCC,
  lib,
  fetchFromGitLab,
  glib,
}:
# We package this manually because upstream stopped updating the package to
# extensions.gnome.org. See:
# https://gitlab.com/ente76/guillotine/-/issues/17
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gnome-shell-extension-guillotine";
  version = "27-unstable-2026-04-08";

  src = fetchFromGitLab {
    owner = "ente76";
    repo = "guillotine";
    rev = "3bccda1d189ed0525daa12f6b12b4ebea4222fc5";
    hash = "sha256-G8u+g1pnitAgGz4+yldIGSNiasgOj32P/M6CVMMDfJY=";
  };

  nativeBuildInputs = [ glib ];

  passthru = {
    extensionUuid = "guillotine@fopdoodle.net";
    extensionPortalSlug = "guillotine";
  };

  buildPhase = ''
    runHook preBuild
    rm schemas/gschemas.compiled
    glib-compile-schemas schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/guillotine@fopdoodle.net
    cp -R schemas "$out/share/gnome-shell/extensions/guillotine@fopdoodle.net"
    cp default.json $out/share/gnome-shell/extensions/guillotine@fopdoodle.net
    cp extension.js "$out/share/gnome-shell/extensions/guillotine@fopdoodle.net"
    cp guillotine-symbolic.svg "$out/share/gnome-shell/extensions/guillotine@fopdoodle.net"
    cp LICENSE "$out/share/gnome-shell/extensions/guillotine@fopdoodle.net"
    cp metadata.json "$out/share/gnome-shell/extensions/guillotine@fopdoodle.net"
    cp README.md "$out/share/gnome-shell/extensions/guillotine@fopdoodle.net"
    runHook postInstall
  '';

  meta = {
    description = "Gnome extension designed for efficiently carrying out executions of commands from a customizable menu";
    homepage = "https://gitlab.com/ente76/guillotine/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ husky ];
    platforms = lib.platforms.linux;
  };
})
