{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  requests,
  click,
  granian,
  httpx,
  packaging,
  platformdirs,
  psutil,
  python-multipart,
  python-socketio,
  redis,
  rich,
  starlette,
  typing-extensions,
  wrapt,

  # sub package dependencies
  aiohttp,
  griffelib,
  mistletoe,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-instrumentation-asgi,
  pyyaml,
  tomli,
  towncrier,
  typing-inspection,
  tzdata,
  email-validator,
  ruff-format,

  # tests
  attrs,
  typer,
  numpy,
  openai,
  opentelemetry-sdk,
  pandas,
  pillow,
  playwright,
  plotly,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  python-dotenv,
  ruff,
  starlette-admin,
  uvicorn,
  gitMinimal,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nodejs-slim,
}:

let

  metaCommon = {
    description = "Web apps in pure Python";
    homepage = "https://github.com/reflex-dev/reflex";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
  };

  buildSubPackage =
    {
      pname,
      version,
      src,
      workspace,
      workspaces,
      subPkgs,
    }:
    buildPythonPackage {
      inherit pname version src;
      pyproject = true;
      sourceRoot = workspace.sourceRoot or "${src.name}/packages/${pname}";

      postPatch = lib.optionalString (pname == "reflex-release") ''
        substituteInPlace pyproject.toml \
          --replace-fail '"hatchling == 1.31.0"' '"hatchling"' \
          --replace-fail '"uv-dynamic-versioning == 0.14.0"' '"uv-dynamic-versioning"'
      '';

      build-system = [
        hatchling
        uv-dynamic-versioning
        ruff
      ]
      ++ lib.optional (pname != "hatch-reflex-pyi") subPkgs.hatch-reflex-pyi;

      pythonRelaxDeps = [ "rich" ];

      preBuild = ''
        # for .ruff_cache and whatnot, written by hatch-reflex-pyi
        chmod -R +w ../..
      '';

      inherit (workspace) dependencies;

      # the top-level package tests everything
      doCheck = false;

      meta = metaCommon;
    };

in

buildPythonPackage (finalAttrs: {
  pname = "reflex";
  version = "0.9.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "reflex-dev";
    repo = "reflex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rGwDSaYtkMZH+pxTT8Tee0OqMxAUlJ5Zii7OddeB2J4=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  pythonRelaxDeps = [
    # pinned to satisfy pyright
    # https://github.com/reflex-dev/reflex/commit/67489196035bacb2e4bb2fe6ae165088bc6db988
    "wrapt"
    # preemptive upper bound, doesn't seem breaking
    "redis"
    "rich"
  ];
  # pythonRelaxDeps is not sufficient
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        '"redis >=6.4,<8.0"' \
        '"redis >=6.4,<9.0"' \
      --replace-fail \
        '"wrapt >=1.17.0,<2.4"' \
        '"wrapt >=1.17.0"'
  '';

  nativeBuildInputs = [
    ruff
  ];

  dependencies =
    let
      inherit (finalAttrs.passthru) subPkgs;
    in
    [
      click
      requests
      granian
      httpx
      openai
      packaging
      psutil
      python-multipart
      python-socketio
      redis
      rich
      starlette
      typing-extensions
      wrapt
      plotly

      subPkgs.reflex-base
      subPkgs.reflex-components-code
      subPkgs.reflex-components-core
      subPkgs.reflex-components-dataeditor
      subPkgs.reflex-components-gridjs
      subPkgs.reflex-components-lucide
      subPkgs.reflex-components-markdown
      subPkgs.reflex-components-moment
      subPkgs.reflex-components-plotly
      subPkgs.reflex-components-radix
      subPkgs.reflex-components-react-player
      subPkgs.reflex-components-recharts
      subPkgs.reflex-components-sonner
      subPkgs.reflex-hosting-cli
    ]
    ++ granian.optional-dependencies.reload;

  nativeCheckInputs =
    let
      inherit (finalAttrs.passthru) subPkgs;
    in
    [
      attrs
      typer
      nodejs-slim
      numpy
      pandas
      pillow
      playwright
      opentelemetry-sdk
      pytest-asyncio
      pytest-mock
      pytestCheckHook
      python-dotenv
      pyyaml
      starlette-admin
      uvicorn
      versionCheckHook
      gitMinimal
      writableTmpDirAsHomeHook
      subPkgs.reflex-build-sdk
      subPkgs.reflex-otel
      subPkgs.reflex-release
    ];
  versionCheckProgramArg = "--version";

  disabledTests = [
    # Touches network
    "test_node_version"

    # /proc is too funky in nix sandbox
    "test_get_cpu_info"

    # flaky
    "test_preprocess" # KeyError: 'reflex___state____state'
    "test_send" # AssertionError: Expected 'post' to have been called once. Called 0 times.
    "test_state_manager_lock" # Lock expired for token 87164611-f...

    # tries to run bun or npm
    "test_output_system_info"

    # reflex.utils.exceptions.StateSerializationError: Failed to serialize state
    # reflex___istate___dynamic____dill_state due to unpicklable object.
    "test_fallback_pickle"

    # AssertionError (mocked_open.call_count == 2)
    "test_delete_token_from_config"

    # circular imports (reflex-docgen)
    "test_compiling_docs_does_not_evaluate_upload"
    "test_enterprise_parent_breadcrumb_uses_overview_route"
    "test_page_names_the_module_the_class_is_defined_in"
  ];

  disabledTestPaths = [
    "tests/benchmarks/"
    "tests/integration/"

    # unable to import agent_files (should be in docs/app/agent_files/)
    "docs/app/tests/test_agent_files.py"
    "docs/app/tests/test_rendered_markdown.py"

    # circular imports (reflex-docgen)
    "tests/units/docgen/test_class_and_component.py"
    "tests/units/docgen/test_markdown.py"
    "tests/units/docgen/test_reflex_transformer.py"
    "docs/app/tests/test_api_reference_layout.py"
    "docs/app/tests/test_breadcrumbs.py"
    "docs/app/tests/test_changelogs.py"
    "docs/app/tests/test_doc_description.py"
    "docs/app/tests/test_doc_links.py"
    "docs/app/tests/test_docgen_double_eval.py"
    "docs/app/tests/test_docpage_pager.py"
    "docs/app/tests/test_docs_landing_links.py"
    "docs/app/tests/test_docs_navbar.py"
    "docs/app/tests/test_frontmatter_meta.py"
    "docs/app/tests/test_overview_pages.py"
    "docs/app/tests/test_redirects.py"
    "docs/app/tests/test_sidebar.py"
    "docs/app/tests/test_site_quality.py"

    # circular imports (reflex-integrations-docs)
    "docs/app/tests/test_integrations.py"

    # circular imports (reflex-components-internal)
    "tests/units/reflex_components_internal/"

    # circular imports (reflex-site-shared)
    "docs/app/tests/test_config.py"
    "docs/app/tests/test_routes.py"
    "tests/units/reflex_site_shared/"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "reflex"
    "reflex.admin"
    "reflex.app"
    "reflex.app_mixins.lifespan"
    "reflex.app_mixins.middleware"
    "reflex.app_mixins.mixin"
    "reflex.assets"
    "reflex.compiler"
    "reflex.components"
    "reflex.config"
    "reflex.constants"
    "reflex.custom_components"
    "reflex.environment"
    "reflex.event"
    "reflex.experimental"
    "reflex.experimental.client_state"
    "reflex.experimental.hooks"
    "reflex.experimental.memo"
    "reflex.istate"
    "reflex.middleware"
    "reflex.model"
    "reflex.page"
    "reflex.plugins"
    "reflex.plugins.sitemap"
    "reflex.plugins.tailwind_v3"
    "reflex.plugins.tailwind_v4"
    "reflex.reflex"
    "reflex.route"
    "reflex.state"
    "reflex.style"
    "reflex.utils"
    "reflex.vars"
  ];

  passthru = {
    # all [tool.uv.sources] workspaces in pyproject.toml
    workspaces =
      let
        inherit (finalAttrs.passthru) subPkgs;
      in
      # this is generated with:
      # ./pkgs/development/python-modules/reflex/mk_workspaces.sh
      {
        hatch-reflex-pyi.dependencies = [
          hatchling
        ];
        reflex-integrations-docs.sourceRoot = "${finalAttrs.src.name}/packages/integrations-docs";
        reflex-integrations-docs.dependencies = [
        ];
        reflex-base.dependencies = [
          packaging
          platformdirs
          rich
          typing-extensions
        ];
        reflex-build-sdk.dependencies = [
          aiohttp
          httpx
          platformdirs
        ];
        reflex-components-code.dependencies = [
          subPkgs.reflex-base
          subPkgs.reflex-components-core
          subPkgs.reflex-components-lucide
          subPkgs.reflex-components-radix
          subPkgs.reflex-components-sonner
          ruff
        ];
        reflex-components-core.dependencies = [
          python-multipart
          subPkgs.reflex-base
          subPkgs.reflex-components-lucide
          subPkgs.reflex-components-sonner
          ruff
          starlette
          typing-extensions
        ];
        reflex-components-dataeditor.dependencies = [
          subPkgs.reflex-base
          subPkgs.reflex-components-core
          subPkgs.reflex-components-lucide
          subPkgs.reflex-components-sonner
          ruff
        ];
        reflex-components-gridjs.dependencies = [
          subPkgs.reflex-base
          ruff
        ];
        reflex-components-internal.dependencies = [
          finalAttrs.finalPackage # reflex
          subPkgs.reflex-base
          subPkgs.reflex-components-code
          subPkgs.reflex-components-core
          subPkgs.reflex-components-dataeditor
          subPkgs.reflex-components-gridjs
          subPkgs.reflex-components-lucide
          subPkgs.reflex-components-markdown
          subPkgs.reflex-components-moment
          subPkgs.reflex-components-plotly
          subPkgs.reflex-components-radix
          subPkgs.reflex-components-react-player
          subPkgs.reflex-components-recharts
          subPkgs.reflex-components-sonner
          subPkgs.reflex-hosting-cli
          ruff
        ];
        reflex-components-lucide.dependencies = [
          subPkgs.reflex-base
          ruff
        ];
        reflex-components-markdown.dependencies = [
          subPkgs.reflex-base
          subPkgs.reflex-components-code
          subPkgs.reflex-components-core
          subPkgs.reflex-components-lucide
          subPkgs.reflex-components-radix
          subPkgs.reflex-components-sonner
          ruff
        ];
        reflex-components-moment.dependencies = [
          subPkgs.reflex-base
          ruff
        ];
        reflex-components-plotly.dependencies = [
          subPkgs.reflex-base
          subPkgs.reflex-components-core
          subPkgs.reflex-components-lucide
          subPkgs.reflex-components-sonner
          ruff
        ];
        reflex-components-radix.dependencies = [
          subPkgs.reflex-base
          subPkgs.reflex-components-core
          subPkgs.reflex-components-lucide
          subPkgs.reflex-components-sonner
          ruff
        ];
        reflex-components-react-player.dependencies = [
          subPkgs.reflex-base
          subPkgs.reflex-components-core
          subPkgs.reflex-components-lucide
          subPkgs.reflex-components-sonner
          ruff
        ];
        reflex-components-recharts.dependencies = [
          subPkgs.reflex-base
          subPkgs.reflex-components-core
          subPkgs.reflex-components-lucide
          subPkgs.reflex-components-sonner
          ruff
        ];
        reflex-components-sonner.dependencies = [
          subPkgs.reflex-base
          subPkgs.reflex-components-lucide
          ruff
        ];
        reflex-docgen.dependencies = [
          griffelib
          mistletoe
          pyyaml
          finalAttrs.finalPackage # reflex
          typing-inspection
        ];
        reflex-hosting-cli.dependencies = [
          click
          httpx
          packaging
          platformdirs
          rich
        ];
        reflex-otel.dependencies = [
          opentelemetry-api
          opentelemetry-instrumentation
          opentelemetry-instrumentation-asgi
          subPkgs.reflex-base
        ];
        reflex-release.dependencies = [
          packaging
          tomli
          towncrier
          tzdata
        ];
        reflex-site-shared.dependencies = [
          email-validator
          httpx
          pyyaml
          finalAttrs.finalPackage # reflex
          subPkgs.reflex-base
          subPkgs.reflex-components-code
          subPkgs.reflex-components-core
          subPkgs.reflex-components-dataeditor
          subPkgs.reflex-components-gridjs
          subPkgs.reflex-components-internal
          subPkgs.reflex-components-lucide
          subPkgs.reflex-components-markdown
          subPkgs.reflex-components-moment
          subPkgs.reflex-components-plotly
          subPkgs.reflex-components-radix
          subPkgs.reflex-components-react-player
          subPkgs.reflex-components-recharts
          subPkgs.reflex-components-sonner
          subPkgs.reflex-docgen
          subPkgs.reflex-hosting-cli
          subPkgs.reflex-integrations-docs
          ruff
          ruff-format
        ];
      };

    inherit buildSubPackage;
    subPkgs = lib.flip lib.mapAttrs finalAttrs.passthru.workspaces (
      pname: workspace:
      (finalAttrs.passthru.buildSubPackage {
        inherit pname workspace;
        inherit (finalAttrs) version src;
        inherit (finalAttrs.passthru) workspaces subPkgs;
      })
    );

    tests = {
      # overridePythonAttrs does not exist for finalAttrs.finalPackage
      reflex-no-checks = finalAttrs.finalPackage.overrideAttrs (old: {
        pname = "${old.pname}-sans-check-phase";
        doCheck = false;
        doInstallCheck = false;
        dontCheckPythonMetadata = true;
      });
    }
    // finalAttrs.passthru.subPkgs;
  };

  meta = metaCommon // {
    changelog = "https://github.com/reflex-dev/reflex/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "reflex";
  };
})
