{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  symlinkJoin,
  versionCheckHook,
  vale,
  valeStyles,
}:

buildGoModule rec {
  pname = "vale";
  version = "3.25.0";

  subPackages = [ "cmd/vale" ];

  src = fetchFromGitHub {
    owner = "vale-cli";
    repo = "vale";
    tag = "v${version}";
    hash = "sha256-Ko+7JkwtnHmNdaeAq0LOjJMrUptbvOzDtGHET9xYSvE=";
  };

  vendorHash = "sha256-cuSjULIbb7JtP0CkX4eFm9RChi3nQW46k5Ik9DyGYKk=";

  # https://github.com/vale-cli/vale/issues/1153
  proxyVendor = true;

  ldflags = [
    "-s"
    "-X main.version=${version}"
  ];

  # Tests require network access
  doCheck = false;
  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.withStyles =
    selector:
    symlinkJoin {
      name = "vale-with-styles-${vale.version}";
      paths = [ vale ] ++ selector valeStyles;
      nativeBuildInputs = [ makeBinaryWrapper ];
      postBuild = ''
        wrapProgram "$out/bin/vale" \
          --set VALE_STYLES_PATH "$out/share/vale/styles/"
      '';
      meta = {
        inherit (vale.meta) mainProgram;
      };
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
    changelog = "https://github.com/vale-cli/vale/releases/tag/v${version}";
    mainProgram = "vale";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
