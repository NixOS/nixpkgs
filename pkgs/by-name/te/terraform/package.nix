{
  stdenv,
  lib,
  buildGo127Module,
  fetchFromGitHub,
  makeWrapper,
  runCommand,
  runtimeShell,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  writeText,
  terraform-providers,
  installShellFiles,
  emptyFile,
}:

let
  package = buildGo127Module rec {
    pname = "terraform";
    version = "1.17.1";

    src = fetchFromGitHub {
      owner = "hashicorp";
      repo = "terraform";
      tag = "v${version}";
      hash = "sha256-/eQWz7J+u7Jt49difHhKqgC60jfLKNFZq25SMKJ16sk=";
    };

    proxyVendor = true; # darwin/linux hash mismatch
    vendorHash = "sha256-FkhDbT6wFmWXARMRGkZDR042/m3fkP9T4ZRzQy5oWRE=";

    patches = [
      ./provider-path-0_15.patch
      # speakeasy hardcodes /bin/stty https://github.com/bgentry/speakeasy/issues/22
      # can't use substituteInPlace for the path in goModules when using proxyVendor so update dependency instead
      ./stty.patch
    ];

    # Set CGO_ENABLED based on platform:
    # - Linux: CGO_ENABLED=0 for static linking (avoids LTO plugin issues)
    # - Darwin: CGO_ENABLED=1 to avoid DNS resolution issues
    # See: https://github.com/hashicorp/terraform/blob/main/BUILDING.md
    env.CGO_ENABLED = if stdenv.hostPlatform.isDarwin then "1" else "0";

    ldflags = [
      "-s"
      "-w"
      "-X 'github.com/hashicorp/terraform/version.dev=no'"
    ];

    nativeBuildInputs = [ installShellFiles ];

    postInstall = ''
      # https://github.com/posener/complete/blob/9a4745ac49b29530e07dc2581745a218b646b7a3/cmd/install/bash.go#L8
      installShellCompletion --bash --name terraform <(echo complete -C terraform terraform)
    '';

    __darwinAllowLocalNetworking = true;

    nativeCheckInputs = [
      writableTmpDirAsHomeHook
      versionCheckHook
    ];

    doInstallCheck = true;
    versionCheckProgramArg = "version";

    subPackages = [ "." ];

    passthru = {
      inherit plugins;
      tests = {
        inherit terraform_plugins_test;
        eval = evalTests emptyFile;
      };
    };

    meta = {
      description = "Tool for building, changing, and versioning infrastructure";
      homepage = "https://www.terraform.io/";
      changelog = "https://github.com/hashicorp/terraform/blob/v${version}/CHANGELOG.md";
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
  };

  terraform_plugins_test =
    let
      mainTf = writeText "main.tf" ''
        terraform {
          required_providers {
            random = {
              source  = "hashicorp/random"
            }
            local = {
              source  = "hashicorp/local"
            }
          }
        }

        resource "random_id" "test" {}
        resource "local_file" "test2" {}
      '';
      terraform =
        ((pluggable package).withPlugins (
          p:
          # If hashicorp_random were to be bundled by default and then
          # null-ed out in the package set, this test would need to switch
          # to a different provider.
          assert lib.isDerivation p.hashicorp_random;
          [ p.hashicorp_random ]
        )).withPlugins
          (
            p:
            assert lib.isDerivation p.hashicorp_local;
            [
              p.hashicorp_local
            ]
          );
      test = runCommand "terraform-plugin-test" { buildInputs = [ terraform ]; } ''
        set -e
        # make it fail outside of sandbox
        export HTTP_PROXY=http://127.0.0.1:0 HTTPS_PROXY=https://127.0.0.1:0
        cp ${mainTf} main.tf
        terraform init
        touch $out
      '';
    in
    test;

  evalTests =
    ok:
    # overrideAttrs works on withPlugins and modifies the unwrapped derivation inside
    # See https://github.com/NixOS/nixpkgs/issues/158620
    assert
      (((pluggable package).withPlugins (p: [ p.hashicorp_random ])).overrideAttrs { name = "squee"; })
      .unwrapped.name == "squee";

    ok;

  pluggable =
    terraform:
    let
      withPlugins =
        plugins:
        let
          actualPlugins = plugins terraform.plugins;

          # Wrap PATH of plugins propagatedBuildInputs, plugins may have runtime dependencies on external binaries
          wrapperInputs = lib.unique (
            lib.flatten (lib.catAttrs "propagatedBuildInputs" (builtins.filter (x: x != null) actualPlugins))
          );

          passthru = {
            withPlugins = newplugins: withPlugins (x: newplugins x ++ actualPlugins);
            full = withPlugins (p: lib.filter lib.isDerivation (lib.attrValues p.actualProviders));

            # Expose wrappers around the override* functions of the terraform
            # derivation.
            #
            # Note that this does not behave as anyone would expect if plugins
            # are specified. The overrides are not on the user-visible wrapper
            # derivation but instead on the function application that eventually
            # generates the wrapper. This means:
            #
            # 1. When using overrideAttrs, only `passthru` attributes will
            #    become visible on the wrapper derivation. Other overrides that
            #    modify the derivation *may* still have an effect, but it can be
            #    difficult to follow.
            #
            # 2. Other overrides may work if they modify the terraform
            #    derivation, or they may have no effect, depending on what
            #    exactly is being changed.
            #
            # 3. Specifying overrides on the wrapper is unsupported.
            #
            # See nixpkgs#158620 for details.
            overrideAttrs = f: (pluggable (terraform.overrideAttrs f)).withPlugins plugins;

            # It could be supported by getting the terraform attribute through
            # callPackage instead, but that wouldn't solve the undoing of
            # overrideAttrs anyway.
            # Until we have https://github.com/NixOS/nixpkgs/issues/273815, we're
            # better off requiring override to go first and save the user
            # potential headaches.
            override = abort "(terraform.withPlugins ...).override is not supported. Call .override before calling any other attributes.";
            # Similarly, except overrideDerivation is on the way out.
            overrideDerivation = abort "(terraform.withPlugins ...).overrideDerivation is not supported. Use overrideAttrs instead.";

            /**
              The terraform package before pinning the plugins with `withPlugins`
            */
            unwrapped = terraform;
          };
        in
        # Don't bother wrapping unless we actually have plugins, since the wrapper will stop automatic downloading
        # of plugins, which might be counterintuitive if someone just wants a vanilla Terraform.
        if actualPlugins == [ ] then
          terraform.overrideAttrs (orig: {
            passthru = orig.passthru // passthru;
          })
        else
          lib.appendToName "with-plugins" (
            stdenv.mkDerivation {
              inherit (terraform) meta pname version;
              nativeBuildInputs = [ makeWrapper ];

              # Expose the passthru set with the override functions
              # defined above, as well as any passthru values already
              # set on `terraform` at this point (relevant in case a
              # user overrides attributes).
              passthru = terraform.passthru // passthru;

              buildCommand = ''
                # Create wrappers for terraform plugins because Terraform only
                # walks inside of a tree of files.
                for providerDir in ${toString actualPlugins}
                do
                  for file in $(find $providerDir/libexec/terraform-providers -type f)
                  do
                    relFile=''${file#$providerDir/}
                    mkdir -p $out/$(dirname $relFile)
                    cat <<WRAPPER > $out/$relFile
                #!${runtimeShell}
                exec "$file" "$@"
                WRAPPER
                    chmod +x $out/$relFile
                  done
                done

                # Create a wrapper for terraform to point it to the plugins dir.
                mkdir -p $out/bin/
                makeWrapper "${terraform}/bin/terraform" "$out/bin/terraform" \
                  --set NIX_TERRAFORM_PLUGIN_DIR $out/libexec/terraform-providers \
                  --prefix PATH : "${lib.makeBinPath wrapperInputs}"
              '';
            }
          );
    in
    withPlugins (_: [ ]);

  plugins = removeAttrs terraform-providers [
    "override"
    "overrideDerivation"
    "recurseForDerivations"
  ];
in
pluggable package
