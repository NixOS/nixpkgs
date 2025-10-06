{
  stdenv,
  lib,
  fetchFromGitLab,
  glib,
}:
# We package this manually because upstream stopped updating the package to
# extensions.gnome.org. See:
# https://gitlab.com/ente76/guillotine/-/issues/17
stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-shell-extension-guillotine";
  version = "26";

  src = fetchFromGitLab {
    owner = "ente76";
    repo = "guillotine";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6RuHargk7sq6oUKj+aGPFp3t0LJCpj6RwLhNzAM5wVA=";
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
