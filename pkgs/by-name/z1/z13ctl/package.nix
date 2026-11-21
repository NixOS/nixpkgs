{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "z13ctl";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "dahui";
    repo = "z13ctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VXZJe7CydX5dIggAF2QAL0SVnoJ4xnD6BeAfi8gTLnU=";
  };

  # Upstream bumped github.com/dahui/z13ctl/api to v1.3.0 in go.mod without updating go.sum
  postPatch = ''
      cat >> go.sum <<EOF
    github.com/dahui/z13ctl/api v1.3.0 h1:ZGvu9ezfgr6vzHfx9As/IlaxK7b4xFQ9uP7yABlu0rs=
    github.com/dahui/z13ctl/api v1.3.0/go.mod h1:WaV3cyrZkszY22RbnJh05/YXMapnP3BcyiAvtyRLnj8=
    EOF
  '';

  vendorHash = "sha256-Fik/Tks4fWNA9uhRj7WTYXQlLcluPXrJq1OATTjhMuo=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dahui/z13ctl/cmd.Version=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Utility for ASUS ROG Flow Z13 (2025)";
    homepage = "https://github.com/dahui/z13ctl";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "z13ctl";
    maintainers = with lib.maintainers; [ badheuristic ];
  };
})
