{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  symlinkJoin,
  versionCheckHook,
  valeStyles,
}:

buildGoModule (finalAttrs: {
  pname = "vale";
  version = "3.26.0";

  subPackages = [ "cmd/vale" ];

  src = fetchFromGitHub {
    owner = "vale-cli";
    repo = "vale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mUABzCStq/gA8vZmqAo+1cuW5vjNyd6XRyH7VYTO4tw=";
  };

  # go mod vendor prunes go-tree-sitter/php/tree_sitter/ because it is
  # headers-only. see https://github.com/golang/go/issues/26366
  proxyVendor = true;
  vendorHash = "sha256-BaJcmBJj86Sohgs5mZtRnlv1h121dUD2CoKvPU4mTEA=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  # Tests require network access
  doCheck = false;
  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.withStyles =
    selector:
    symlinkJoin {
      name = "vale-with-styles-${finalAttrs.version}";
      paths = [ finalAttrs.finalPackage ] ++ selector valeStyles;
      nativeBuildInputs = [ makeBinaryWrapper ];
      postBuild = ''
        wrapProgram "$out/bin/vale" \
          --set VALE_STYLES_PATH "$out/share/vale/styles/"
      '';
      meta.mainProgram = finalAttrs.meta.mainProgram;
    };

  meta = {
    description = "Syntax-aware linter for prose built with speed and extensibility in mind";
    longDescription = ''
      Vale in Nixpkgs offers the helper `.withStyles` allow you to install it
      predefined styles:

      ```nix
      vale.withStyles (s: [ s.alex s.google ])
      ```
    '';
    homepage = "https://vale.sh/";
    changelog = "https://github.com/vale-cli/vale/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "vale";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
  };
})
