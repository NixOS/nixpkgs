{
  lib,
  runCommand,
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  click-default-group,
  condense-json,
  numpy,
  openai,
  pip,
  pluggy,
  puremagic,
  pydantic,
  python,
  python-ulid,
  pyyaml,
  sqlite-migrate,
  cogapp,
  pytest-asyncio,
  pytest-httpx,
  sqlite-utils,
}:
let
  # The function signature of `withPlugins` is the list of all the plugins `llm` knows about.
  # The plugin directory is at <https://llm.datasette.io/en/stable/plugins/directory.html>
  withPluginsArgNames = lib.functionArgs withPlugins;

  /**
    Make a derivation for `llm` that contains `llm` plus the relevant plugins.

    # Type

    ```
    withPlugins ::
      {
        llm-anthropic :: bool,
        llm-gemini :: bool,
        ...
      }
      -> derivation
    ```

    See `lib.attrNames (lib.functionArgs llm.withPlugins)` for the total list of plugins supported.

    # Examples
    :::{.example}
    ## `llm.withPlugins` usage example

    ```nix
    llm.withPlugins { llm-gemini = true; llm-groq = true; }
    => «derivation /nix/store/<hash>-python3-3.12.10-llm-with-llm-gemini-llm-groq.drv»
    ```

    :::
  */
  withPlugins =
    # Keep this list up to date with the plugins in python3Packages!
    {
      llm-anthropic ? false,
      llm-cmd ? false,
      llm-command-r ? false,
      llm-deepseek ? false,
      llm-fragments-github ? false,
      llm-fragments-pypi ? false,
      llm-gemini ? false,
      llm-gguf ? false,
      llm-grok ? false,
      llm-groq ? false,
      llm-hacker-news ? false,
      llm-jq ? false,
      llm-mistral ? false,
      llm-ollama ? false,
      llm-openai-plugin ? false,
      llm-openrouter ? false,
      llm-sentence-transformers ? false,
      llm-templates-fabric ? false,
      llm-templates-github ? false,
      llm-venice ? false,
      llm-video-frames ? false,
    }@args:
    let
      # Filter to just the attributes which are set to a true value.
      setArgs = lib.filterAttrs (name: lib.id) args;

      # Make a string with those names separated with a dash.
      setArgsStr = lib.concatStringsSep "-" (lib.attrNames setArgs);

      # Make the derivation name reflect what's inside it.
      drvName = if lib.stringLength setArgsStr == 0 then "llm" else "llm-with-${setArgsStr}";

      # Make a python environment with just those plugins.
      python-environment = python.withPackages (
        ps:
        let
          # Throw a diagnostic if this list gets out of sync with the names in python3Packages
          allPluginsPresent = pluginNames == (lib.attrNames withPluginsArgNames);
          pluginNames = lib.attrNames (lib.intersectAttrs ps withPluginsArgNames);
          missingNamesList = lib.attrNames (lib.removeAttrs withPluginsArgNames pluginNames);
          missingNames = lib.concatStringsSep ", " missingNamesList;

          # The relevant plugins are the ones the user asked for.
          plugins = lib.intersectAttrs setArgs ps;
        in
        assert lib.assertMsg allPluginsPresent "Missing these plugins: ${missingNames}";
        ([ ps.llm ] ++ lib.attrValues plugins)
      );

    in
    # That Python environment produced above contains too many irrelevant binaries, due to how
    # Python needs to use propagatedBuildInputs. Let's make one with just what's needed: `llm`.
    # Since we include the `passthru` and `meta` information, it's as good as the original
    # derivation.
    runCommand "${python.name}-${drvName}" { inherit (llm) passthru meta; } ''
      mkdir -p $out/bin
      ln -s ${python-environment}/bin/llm $out/bin/llm
    '';

  # Uses the `withPlugins` names to make a Python environment with everything.
  withAllPlugins = withPlugins (lib.genAttrs (lib.attrNames withPluginsArgNames) (name: true));

  llm = buildPythonPackage rec {
    pname = "llm";
    version = "0.25";
    pyproject = true;

    build-system = [ setuptools ];

    disabled = pythonOlder "3.8";

    src = fetchFromGitHub {
      owner = "simonw";
      repo = "llm";
      tag = version;
      hash = "sha256-iH1P0VdpwIItY1In7vlM0Sn44Db23TqFp8GZ79/GMJs=";
    };

    patches = [ ./001-disable-install-uninstall-commands.patch ];

    dependencies = [
      click-default-group
      condense-json
      numpy
      openai
      pip
      pluggy
      puremagic
      pydantic
      python-ulid
      pyyaml
      setuptools # for pkg_resources
      sqlite-migrate
      sqlite-utils
    ];

    nativeCheckInputs = [
      cogapp
      numpy
      pytest-asyncio
      pytest-httpx
      pytestCheckHook
    ];

    doCheck = true;

    pytestFlagsArray = [
      "-svv"
      "tests/"
    ];

    pythonImportsCheck = [ "llm" ];

    passthru = {
      inherit withPlugins withAllPlugins;

      mkPluginTest = plugin: {
        ${plugin.pname} = callPackage ./mk-plugin-test.nix { inherit llm plugin; };
      };
    };

    meta = with lib; {
      homepage = "https://github.com/simonw/llm";
      description = "Access large language models from the command-line";
      changelog = "https://github.com/simonw/llm/releases/tag/${src.tag}";
      license = licenses.asl20;
      mainProgram = "llm";
      maintainers = with maintainers; [
        aldoborrero
        mccartykim
      ];
    };
  };
in
llm
