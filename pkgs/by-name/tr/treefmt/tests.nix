{
  lib,
  runCommand,
  testers,
  treefmt,
  nixfmt,
}:
let
  inherit (treefmt) buildConfig withConfig;

  testEqualContents =
    args:
    testers.testEqualContents (
      args
      // lib.optionalAttrs (builtins.isString args.expected) {
        expected = builtins.toFile "expected" args.expected;
      }
    );

  nixfmtExampleConfig = {
    on-unmatched = "info";
    tree-root-file = ".git/index";

    formatter.nixfmt = {
      command = "nixfmt";
      includes = [ "*.nix" ];
    };
  };

  nixfmtExamplePackage = withConfig {
    settings = nixfmtExampleConfig;
    runtimeInputs = [ nixfmt ];
  };
in
{
  buildConfigEmpty = testEqualContents {
    assertion = "`buildConfig { }` builds an empty config file";
    actual = buildConfig { };
    expected = "";
  };

  buildConfigExample = testEqualContents {
    assertion = "`buildConfig` builds the example config";
    actual = buildConfig nixfmtExampleConfig;
    expected = ''
      on-unmatched = "info"
      tree-root-file = ".git/index"
      [formatter.nixfmt]
      command = "nixfmt"
      includes = ["*.nix"]
    '';
  };

  buildConfigModules = testEqualContents {
    assertion = "`buildConfig` evaluates modules to build a config";
    actual = buildConfig [
      nixfmtExampleConfig
      { tree-root-file = lib.mkForce "overridden"; }
    ];
    expected = ''
      on-unmatched = "info"
      tree-root-file = "overridden"
      [formatter.nixfmt]
      command = "nixfmt"
      includes = ["*.nix"]
    '';
  };

  runNixfmtExample =
    runCommand "run-nixfmt-example"
      {
        nativeBuildInputs = [ nixfmtExamplePackage ];
        passAsFile = [
          "input"
          "expected"
        ];
        input = ''
          {
            foo="bar";
            attrs={};
            list=[];
          }
        '';
        expected = ''
          {
            foo = "bar";
            attrs = { };
            list = [ ];
          }
        '';
      }
      ''
        export XDG_CACHE_HOME=$(mktemp -d)
        # The example config assumes the tree root has a .git/index file
        mkdir .git && touch .git/index

        # Copy the input file, then format it using the wrapped treefmt
        cp $inputPath input.nix
        treefmt

        # Assert that input.nix now matches expected
        if diff -u $expectedPath input.nix; then
          touch $out
        else
          echo
          echo "treefmt did not format input.nix as expected"
          exit 1
        fi
      '';
}
