{
  lib,
  stdenvNoCC,
  bash,
  fetchFromGitHub,
  gettext,
  python3,
  libsecret,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tidesi";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "Muddyblack";
    repo = "tidesi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0pKW+8WyGFoSx2MfbS6+0VhfYjm5gUyfRAWYayVpuhk=";
  };

  nativeBuildInputs = [ gettext ];

  # strictDeps: patchShebangs only rewrites `#!/usr/bin/env bash` to an
  # interpreter that is a runtime input.
  buildInputs = [ bash ];
  strictDeps = true;
  __structuredAttrs = true;
  dontConfigure = true;

  # The package is assembled from the shared sources, which also compiles the
  # .mo catalogs.
  buildPhase = ''
    runHook preBuild
    bash scripts/build-kde-package.sh build/kde
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    root=$out/share/plasma/plasmoids/org.muddyblack.tidesi
    mkdir -p "$root"
    cp -r build/kde/. "$root/"

    # plasmashell inherits the systemd user session's PATH, which on NixOS has
    # no Python at all: pin the interpreter so the widget is self-contained.
    # $PYTHON3 still wins at runtime. --replace-fail turns a drifted line into
    # a build error instead of a silently unpatched script.
    substituteInPlace "$root/contents/backend/sh/python-interp.sh" \
      --replace-fail 'PY_DEFAULT="python3"' \
                     'PY_DEFAULT="${lib.getExe python3}"'
    # Remote devices reuse Antigravity's Secret Service credential.
    substituteInPlace "$root/contents/backend/tidesi/providers/antigravity_remote.py" \
      --replace-fail 'SECRET_TOOL = "secret-tool"' \
                     'SECRET_TOOL = "${lib.getExe' libsecret "secret-tool"}"'

    # Register the icon in the hicolor theme so the Widget Explorer finds it.
    install -Dm644 assets/icons/org.muddyblack.tidesi.svg \
      "$out/share/icons/hicolor/scalable/apps/org.muddyblack.tidesi.svg"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    root=$out/share/plasma/plasmoids/org.muddyblack.tidesi
    test -f "$root/metadata.json"
    test -f "$root/contents/ui/main.qml"
    # The catalogs are not in git: a pack that skipped them ships English only.
    ls "$root"/contents/locale/*/LC_MESSAGES/*.mo > /dev/null
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-provider AI usage limits as a KDE Plasma 6 panel widget";
    homepage = "https://github.com/Muddyblack/tidesi";
    changelog = "https://github.com/Muddyblack/tidesi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.muddyblack ];
  };
})
