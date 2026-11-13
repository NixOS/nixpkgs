{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  nix-update-script,
  python3,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "venus-protocol";
  version = "1.1.3";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "virgl";
    repo = "venus-protocol";
    tag = "v${finalAttrs.version}";
    hash = "sha256-epSb26uLAbHYBDr+ju6rzFu4ozD/LUpRuou6hA/BFRM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    python3
    python3Packages.mako
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Venus virtio protocol specification";
    homepage = "https://gitlab.freedesktop.org/virgl/venus-protocol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ k900 ];
    platforms = lib.platforms.all;
  };
})
