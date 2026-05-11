{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "yamlfmt";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "yamlfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tiPTTAPqXp8ptEKsAII3sTiMCneiWEXg4pl2F1Nb+8A=";
    leaveDotGit = true;
    postFetch = ''
      git -C "$out" rev-parse --short HEAD > "$out/.git_head"
      rm -rf "$out/.git"
    '';
  };

  vendorHash = "sha256-UTfbfAjmWKrHr/YxaWuaFswF3EnqcE8Otnz/sPoYT5w=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  preBuild = ''
    ldflags+=" -X=main.commit=$(<.git_head)"
  '';

  # Test failure in vendored yaml package, see:
  # https://github.com/google/yamlfmt/issues/256
  checkFlags = [ "-run=!S/TestNodeRoundtrip" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Extensible command line tool or library to format yaml files";
    homepage = "https://github.com/google/yamlfmt";
    changelog = "https://github.com/google/yamlfmt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "yamlfmt";
  };
})
