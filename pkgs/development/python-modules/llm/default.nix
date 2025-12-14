{
  lib,
  runCommand,
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  replaceVars,
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
  pytest-recording,
  sqlite-utils,
  syrupy,
  llm-echo,
}:
let
  /**
    Make a derivation for `llm` that contains `llm` plus the relevant plugins.
    The function signature of `withPlugins` is the list of all the plugins `llm` knows about.
    Adding a parameter here requires that it be in `python3Packages` attrset.

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
      llm-docs ? false,
      llm-echo ? false,
      llm-fragments-github ? false,
      llm-fragments-pypi ? false,
      llm-fragments-reader ? false,
      llm-fragments-symbex ? false,
      llm-gemini ? false,
      llm-gguf ? false,
      llm-git ? false,
      llm-github-copilot ? false,
      llm-grok ? false,
      llm-groq ? false,
      llm-hacker-news ? false,
      llm-jq ? false,
      llm-llama-server ? false,
      llm-mistral ? false,
      llm-ollama ? false,
      llm-openai-plugin ? false,
      llm-openrouter ? false,
      llm-pdf-to-images ? false,
      llm-perplexity ? false,
      llm-sentence-transformers ? false,
      llm-templates-fabric ? false,
      llm-templates-github ? false,
      llm-tools-datasette ? false,
      llm-tools-quickjs ? false,
      llm-tools-simpleeval ? false,
      llm-tools-sqlite ? false,
      llm-venice ? false,
      llm-video-frames ? false,
      ...
    }@args:
    let
      # Filter to just the attributes which are set to a true value.
      setArgs = lib.filterAttrs (name: lib.id) args;

      # Make the derivation name reflect what's inside it, up to a certain limit.
      setArgNames = lib.attrNames setArgs;
      drvName =
        let
          len = builtins.length setArgNames;
        in
        if len == 0 then
          "llm-${llm.version}"
        else if len > 20 then
          "llm-${llm.version}-with-${toString len}-plugins"
        else
          # Make a string with those names separated with a dash.
          "llm-${llm.version}-with-${lib.concatStringsSep "-" setArgNames}";

      # Make a python environment with just those plugins.
      python-environment = python.withPackages (
        ps:
        let
          # Throw a diagnostic if this list gets out of sync with the names in python3Packages
          allPluginsPresent = pluginNames == withPluginsArgNames;
          pluginNames = lib.attrNames (lib.intersectAttrs ps withPluginsArgs);
          missingNamesList = lib.attrNames (lib.removeAttrs withPluginsArgs pluginNames);
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
  withAllPlugins = withPlugins (lib.genAttrs withPluginsArgNames (name: true));

  # The function signature of `withPlugins` is the list of all the plugins `llm` knows about.
  # The plugin directory is at <https://llm.datasette.io/en/stable/plugins/directory.html>
  withPluginsArgs = lib.functionArgs withPlugins;
  withPluginsArgNames = lib.attrNames withPluginsArgs;

  # In order to help with usability, we patch `llm install` and `llm uninstall` to tell users how to
  # customize `llm` with plugins in Nix, including the name of the plugin, its description, and
  # where it's coming from.
  listOfPackagedPlugins = builtins.toFile "plugins.txt" (
    lib.concatStringsSep "\n  " (
      map (name: ''
        # ${python.pkgs.${name}.meta.description} <${python.pkgs.${name}.meta.homepage}>
          ${name} = true;
      '') withPluginsArgNames
    )
  );

  llm = buildPythonPackage rec {
    pname = "llm";
    version = "0.27.1";
    pyproject = true;

    build-system = [ setuptools ];

    disabled = pythonOlder "3.8";

    src = fetchFromGitHub {
      owner = "simonw";
      repo = "llm";
      tag = version;
      hash = "sha256-HWzuPhI+oiCKBeiHK7x9Sc54ZB88Py60FzprMLlZGrY=";
    };

    patches = [ ./001-disable-install-uninstall-commands.patch ];

    postPatch = ''
      substituteInPlace llm/cli.py \
        --replace-fail "@listOfPackagedPlugins@" "$(< ${listOfPackagedPlugins})"
    '';

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
      pytest-recording
      syrupy
      pytestCheckHook
    ];

    doCheck = true;

    # The tests make use of `llm_echo` but that would be a circular dependency.
    # So we make a local copy in this derivation, as it's a super-simple package of one file.
    preCheck = ''
      cp ${llm-echo.src}/llm_echo.py llm_echo.py
    '';

    pytestFlags = [
      "-svv"
    ];

    enabledTestPaths = [
      "tests/"
    ];

    disabledTests = [
      # AssertionError: The following responses are mocked but not requested:
      # - Match POST request on https://api.openai.com/v1/chat/completions
      # https://github.com/simonw/llm/issues/1292
      "test_gpt4o_mini_sync_and_async"

      # TypeError: CliRunner.__init__() got an unexpected keyword argument 'mix_stderr
      # https://github.com/simonw/llm/issues/1293
      "test_embed_multi_files_encoding"
    ];

    pythonImportsCheck = [ "llm" ];

    passthru = {
      inherit withPlugins withAllPlugins;

      mkPluginTest = plugin: {
        ${plugin.pname} = callPackage ./mk-plugin-test.nix { inherit llm plugin; };
      };

      # include tests for all the plugins
      tests = lib.mergeAttrsList (map (name: python.pkgs.${name}.tests) withPluginsArgNames);
    };

    meta = {
      homepage = "https://github.com/simonw/llm";
      description = "Access large language models from the command-line";
      changelog = "https://github.com/simonw/llm/releases/tag/${src.tag}";
      license = lib.licenses.asl20;
      mainProgram = "llm";
      maintainers = with lib.maintainers; [
        aldoborrero
        mccartykim
        philiptaron
      ];
    };
  };
in
llm
