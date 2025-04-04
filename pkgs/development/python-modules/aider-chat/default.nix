{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  gitMinimal,
  portaudio,
  playwright-driver,
  symlinkJoin,
  nltk-data,
  pythonOlder,
  pythonAtLeast,
  setuptools-scm,
  aiohappyeyeballs,
  aiohttp,
  aiosignal,
  annotated-types,
  anyio,
  attrs,
  backoff,
  beautifulsoup4,
  certifi,
  cffi,
  charset-normalizer,
  click,
  configargparse,
  diff-match-patch,
  diskcache,
  distro,
  filelock,
  flake8,
  frozenlist,
  fsspec,
  gitdb,
  gitpython,
  grep-ast,
  h11,
  httpcore,
  httpx,
  huggingface-hub,
  idna,
  importlib-resources,
  jinja2,
  jiter,
  json5,
  jsonschema,
  jsonschema-specifications,
  litellm,
  markdown-it-py,
  markupsafe,
  mccabe,
  mdurl,
  multidict,
  networkx,
  numpy,
  openai,
  packaging,
  pathspec,
  pexpect,
  pillow,
  prompt-toolkit,
  psutil,
  ptyprocess,
  pycodestyle,
  pycparser,
  pydantic,
  pydantic-core,
  pydub,
  pyflakes,
  pygments,
  pypandoc,
  pyperclip,
  python-dotenv,
  pyyaml,
  referencing,
  regex,
  requests,
  rich,
  rpds-py,
  scipy,
  smmap,
  sniffio,
  sounddevice,
  socksio,
  soundfile,
  soupsieve,
  tiktoken,
  tokenizers,
  tqdm,
  tree-sitter,
  tree-sitter-language-pack,
  typing-extensions,
  typing-inspection,
  urllib3,
  watchfiles,
  wcwidth,
  yarl,
  zipp,
  pip,
  mixpanel,
  monotonic,
  posthog,
  propcache,
  python-dateutil,
  pytestCheckHook,
  greenlet,
  playwright,
  pyee,
  streamlit,
  llama-index-core,
  llama-index-embeddings-huggingface,
  torch,
  nltk,
  boto3,
}:

let
  aider-nltk-data = symlinkJoin {
    name = "aider-nltk-data";
    paths = [
      nltk-data.punkt_tab
      nltk-data.stopwords
    ];
  };

  version = "0.81.1";
  aider-chat = buildPythonPackage {
    pname = "aider-chat";
    inherit version;
    pyproject = true;

    # needs exactly Python 3.12
    disabled = pythonOlder "3.12" || pythonAtLeast "3.13";

    src = fetchFromGitHub {
      owner = "Aider-AI";
      repo = "aider";
      tag = "v${version}";
      hash = "sha256-TNSdsJBmF/9OCkFe1dZV0y7X2FSTjgp3YV4HGlA9GMc=";
    };

    pythonRelaxDeps = true;

    build-system = [ setuptools-scm ];

    dependencies = [
      aiohappyeyeballs
      aiohttp
      aiosignal
      annotated-types
      anyio
      attrs
      backoff
      beautifulsoup4
      certifi
      cffi
      charset-normalizer
      click
      configargparse
      diff-match-patch
      diskcache
      distro
      filelock
      flake8
      frozenlist
      fsspec
      gitdb
      gitpython
      grep-ast
      h11
      httpcore
      httpx
      huggingface-hub
      idna
      importlib-resources
      jinja2
      jiter
      json5
      jsonschema
      jsonschema-specifications
      litellm
      markdown-it-py
      markupsafe
      mccabe
      mdurl
      multidict
      networkx
      numpy
      openai
      packaging
      pathspec
      pexpect
      pillow
      prompt-toolkit
      psutil
      ptyprocess
      pycodestyle
      pycparser
      pydantic
      pydantic-core
      pydub
      pyflakes
      pygments
      pypandoc
      pyperclip
      python-dotenv
      pyyaml
      referencing
      regex
      requests
      rich
      rpds-py
      scipy
      smmap
      sniffio
      sounddevice
      socksio
      soundfile
      soupsieve
      tiktoken
      tokenizers
      tqdm
      tree-sitter
      tree-sitter-language-pack
      typing-extensions
      typing-inspection
      urllib3
      watchfiles
      wcwidth
      yarl
      zipp
      pip

      # Not listed in requirements
      mixpanel
      monotonic
      posthog
      propcache
      python-dateutil
    ];

    buildInputs = [ portaudio ];

    nativeCheckInputs = [
      pytestCheckHook
      gitMinimal
    ];

    disabledTestPaths = [
      # Tests require network access
      "tests/scrape/test_scrape.py"
      # Expected 'mock' to have been called once
      "tests/help/test_help.py"
    ];

    disabledTests =
      [
        # Tests require network
        "test_urls"
        "test_get_commit_message_with_custom_prompt"
        # FileNotFoundError
        "test_get_commit_message"
        # Expected 'launch_gui' to have been called once
        "test_browser_flag_imports_streamlit"
        # AttributeError
        "test_simple_send_with_retries"
        # Expected 'check_version' to have been called once
        "test_main_exit_calls_version_check"
        # AssertionError: assert 2 == 1
        "test_simple_send_non_retryable_error"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        # Tests fails on darwin
        "test_dark_mode_sets_code_theme"
        "test_default_env_file_sets_automatic_variable"
        # FileNotFoundError: [Errno 2] No such file or directory: 'vim'
        "test_pipe_editor"
      ];

    makeWrapperArgs = [
      "--set"
      "AIDER_CHECK_UPDATE"
      "false"
      "--set"
      "AIDER_ANALYTICS"
      "false"
    ];

    preCheck = ''
      export HOME=$(mktemp -d)
      export AIDER_ANALYTICS="false"
    '';

    optional-dependencies = {
      playwright = [
        greenlet
        playwright
        pyee
        typing-extensions
      ];
      browser = [
        streamlit
      ];
      help = [
        llama-index-core
        llama-index-embeddings-huggingface
        torch
        nltk
      ];
      bedrock = [
        boto3
      ];
    };

    passthru = {
      withOptional =
        {
          withPlaywright ? false,
          withBrowser ? false,
          withHelp ? false,
          withBedrock ? false,
          withAll ? false,
          ...
        }:
        aider-chat.overridePythonAttrs (
          {
            dependencies,
            makeWrapperArgs,
            propagatedBuildInputs ? [ ],
            ...
          }:
          let
            playwrightDeps =
              if withPlaywright || withAll then aider-chat.optional-dependencies.playwright else [ ];
            browserDeps = if withBrowser || withAll then aider-chat.optional-dependencies.browser else [ ];
            helpDeps = if withHelp || withAll then aider-chat.optional-dependencies.help else [ ];
            bedrockDeps = if withBedrock || withAll then aider-chat.optional-dependencies.bedrock else [ ];

            playwrightInputs = if withPlaywright || withAll then [ playwright-driver.browsers ] else [ ];
            playwrightArgs =
              if withPlaywright || withAll then
                [
                  "--set"
                  "PLAYWRIGHT_BROWSERS_PATH"
                  "${playwright-driver.browsers}"
                  "--set"
                  "PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS"
                  "true"
                ]
              else
                [ ];
            helpArgs =
              if withHelp || withAll then
                [
                  "--set"
                  "NLTK_DATA"
                  "${aider-nltk-data}"
                ]
              else
                [ ];
          in
          {
            dependencies = dependencies ++ playwrightDeps ++ browserDeps ++ helpDeps ++ bedrockDeps;
            propagatedBuildInputs = propagatedBuildInputs ++ playwrightInputs;
            makeWrapperArgs = makeWrapperArgs ++ playwrightArgs ++ helpArgs;
          }
        );
    };

    meta = {
      description = "AI pair programming in your terminal";
      homepage = "https://github.com/paul-gauthier/aider";
      changelog = "https://github.com/paul-gauthier/aider/blob/v${version}/HISTORY.md";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ happysalada ];
      mainProgram = "aider";
    };
  };
in
aider-chat
