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
  pydantic,
  griffelib,
  mistletoe,
  pyyaml,
  typing-inspection,
  email-validator,
  ruff-format,

  # tests
  attrs,
  typer,
  numpy,
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
  versionCheckHook,
  writableTmpDirAsHomeHook,
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
      sourceRoot = "${src.name}/packages/${pname}";

      build-system = [
        hatchling
        uv-dynamic-versioning
        ruff
      ]
      ++ lib.optional (pname != "hatch-reflex-pyi") subPkgs.hatch-reflex-pyi;

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
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "reflex-dev";
    repo = "reflex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YYy/K4AXeh9wS4Vodg3NOqwolPYHTgpP5/yWkutMsxo=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

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

  nativeCheckInputs = [
    attrs
    typer
    numpy
    pandas
    pillow
    playwright
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    python-dotenv
    starlette-admin
    uvicorn
    versionCheckHook
    writableTmpDirAsHomeHook
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
  ];

  disabledTestPaths = [
    "tests/benchmarks/"
    "tests/integration/"

    # circular imports (reflex-docgen)
    "tests/units/docgen/test_class_and_component.py"
    "tests/units/docgen/test_markdown.py"
    "docs/app/tests/test_docgen_double_eval.py"

    # circular imports (reflex_site_shared)
    "docs/app/tests/test_routes.py"
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
        integrations-docs.dependencies = [
        ];
        reflex-base.dependencies = [
          packaging
          platformdirs
          pydantic
          rich
          typing-extensions
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
          typing-extensions
          typing-inspection
        ];
        reflex-hosting-cli.dependencies = [
          click
          httpx
          packaging
          platformdirs
          rich
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
          subPkgs.reflex-hosting-cli
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
      reflex-no-checks = finalAttrs.finalPackage.overrideAttrs (old: {
        pname = "${old.pname}-sans-checks-phase";
        doCheck = false;
        nativeCheckInputs = [ ];
      });
    }
    // finalAttrs.passthru.subPkgs;
  };

  meta = metaCommon // {
    changelog = "https://github.com/reflex-dev/reflex/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "reflex";
  };
})
