{
  stdenv,
  lib,
  buildGo127Module,
  fetchFromGitHub,
  makeWrapper,
  runCommand,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  writeText,
  terraform-providers,
  installShellFiles,
}:

buildGo127Module (finalAttrs: {
  pname = "terraform";
  version = "1.17.1";
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/eQWz7J+u7Jt49difHhKqgC60jfLKNFZq25SMKJ16sk=";
  };

  patches = [
    ./provider-path-0_15.patch
    # speakeasy hardcodes /bin/stty https://github.com/bgentry/speakeasy/issues/22
    # can't use substituteInPlace for the path in goModules when using proxyVendor so update dependency instead
    ./stty.patch
  ];

  postPatch = ''
    # Between go 1.23 and 1.24 the following GODEBUG setting was removed, and a new
    # similar one was added.
    # https://github.com/golang/go/issues/72111
    # The setting is configured upstream due to the following timeouts caused by
    # the TLS handshake using post-quantum crypto with servers that don't support it
    # https://tldr.fail/
    substituteInPlace go.mod \
      --replace-quiet 'godebug tlskyber=0' 'godebug tlsmlkem=0'
  '';

  subPackages = [ "." ];
  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-FkhDbT6wFmWXARMRGkZDR042/m3fkP9T4ZRzQy5oWRE=";
  env.CGO_ENABLED = if stdenv.hostPlatform.isDarwin then "1" else "0";
  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/hashicorp/terraform/version.dev=no"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # https://github.com/posener/complete/blob/9a4745ac49b29530e07dc2581745a218b646b7a3/cmd/install/bash.go#L8
  postInstall = ''
      installShellCompletion --bash --name terraform <(echo complete -C terraform terraform)
  '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "version";

  preCheck = ''
    export TF_SKIP_REMOTE_TESTS=1
  '';

  passthru = {
    withPlugins =
      pluginFunction:
      let
        actualPlugins = pluginFunction finalAttrs.finalPackage.plugins;

        # Wrap PATH of plugins propagatedBuildInputs, plugins may have runtime dependencies on external binaries
        wrapperInputs = lib.unique (
          lib.flatten (lib.catAttrs "propagatedBuildInputs" (builtins.filter (x: x != null) actualPlugins))
        );
      in
      # Don't bother wrapping unless we actually have plugins, since the wrapper will stop automatic downloading
      # of plugins, which might be counterintuitive if someone just wants a vanilla Terraform.
      if actualPlugins != [ ] then
        lib.appendToName "with-plugins" (
          stdenv.mkDerivation {
            inherit (finalAttrs.finalPackage)
              meta
              pname
              version
              ;
            nativeBuildInputs = [ makeWrapper ];

            buildCommand = ''
              # Create wrappers for terraform plugins because Terraform only
              # walks inside of a tree of files.
              for providerDir in ${toString actualPlugins}
              do
                for file in $(find $providerDir/libexec/terraform-providers -type f)
                do
                  relFile=''${file#$providerDir/}
                  mkdir -p $out/$(dirname $relFile)
                  makeWrapper "$file" "$out/$relFile"
                done
              done

              # Create a wrapper for terraform to point it to the plugins dir.
              mkdir -p $out/bin/
              makeWrapper "${lib.getExe finalAttrs.finalPackage}" "$out/bin/${finalAttrs.finalPackage.meta.mainProgram}" \
                --set NIX_TERRAFORM_PLUGIN_DIR $out/libexec/terraform-providers \
                --prefix PATH : "${lib.makeBinPath wrapperInputs}"
            '';
          }
        )
      else
        finalAttrs.finalPackage;
    full = finalAttrs.finalPackage.withPlugins (
      p: lib.filter lib.isDerivation (lib.attrValues p.actualProviders)
    );
    plugins = removeAttrs terraform-providers [
      "override"
      "overrideDerivation"
      "recurseForDerivations"
    ];

    tests = {
      terraform_plugins_test =
        let
          mainTf = writeText "main.tf" ''
            terraform {
              required_providers {
                random = {
                  source  = "hashicorp/random"
                }
              }
            }

            resource "random_id" "server" {
              keepers = {
                ami_id = var.ami_id
              }

              byte_length = 8
            }
          '';
          terraform = finalAttrs.finalPackage.withPlugins (p: [ p.hashicorp_random ]);
        in
        runCommand "terraform-plugin-test" { buildInputs = [ terraform ]; } ''
          cp ${mainTf} main.tf
          terraform init -backend=false -json-into=$out
        '';
    };
  };

  meta = {
    description = "Tool for building, changing, and versioning infrastructure";
    homepage = "https://www.terraform.io/";
    changelog = "https://github.com/hashicorp/terraform/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [
      Chili-Man
      kalbasit
      timstott
      zimbatm
      zowoq
      techknowlogick
      qjoly
    ];
    mainProgram = "terraform";
  };
})
