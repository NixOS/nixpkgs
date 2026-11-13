{
  lib,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  hishel,
  httpx,
  pydantic,
  pyjwt,
  pytest-cov-stub,
  pytestCheckHook,
  typing-extensions,
  uv-build,
}:

let

  mkGithubkitSchema =
    {
      pname,
      version,
      src,
    }:
    buildPythonPackage {
      inherit pname version src;
      sourceRoot = "${src.name}/packages/${pname}";
      pyproject = true;

      # circular dependencies
      pythonRemoveDeps = [
        "githubkit"
        "githubkit-schemas"
      ];

      postPatch = ''
        substituteInPlace pyproject.toml \
          --replace-fail "uv_build >=0.8.3, <0.12.0" "uv_build"
      '';

      build-system = [ uv-build ];
    };

in

buildPythonPackage (finalAttrs: {
  pname = "githubkit";
  version = "0.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yanyongyu";
    repo = "githubkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B7E6UioiZArydnmTZmA8DJ0FDkoB362T/u+74iq3MEM=";
  };

  passthru.schemas = {
    githubkit-schemas = mkGithubkitSchema {
      pname = "githubkit-schemas";
      version = "26.10.28";
      inherit (finalAttrs) src;
    };

    githubkit-schemas-2022-11-28 = mkGithubkitSchema {
      pname = "githubkit-schemas-2022-11-28";
      version = "26.10.28";
      inherit (finalAttrs) src;
    };

    githubkit-schemas-2026-03-10 = mkGithubkitSchema {
      pname = "githubkit-schemas-2026-03-10";
      version = "26.10.28";
      inherit (finalAttrs) src;
    };

    githubkit-schemas-ghec-2022-11-28 = mkGithubkitSchema {
      pname = "githubkit-schemas-ghec-2022-11-28";
      version = "26.10.28";
      inherit (finalAttrs) src;
    };

    githubkit-schemas-ghec-2026-03-10 = mkGithubkitSchema {
      pname = "githubkit-schemas-ghec-2026-03-10";
      version = "26.10.28";
      inherit (finalAttrs) src;
    };
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build >=0.8.3, <0.12.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [
    anyio
    httpx
    hishel
    typing-extensions
    pydantic
  ]
  ++ hishel.optional-dependencies.async
  ++ hishel.optional-dependencies.httpx
  # for simplicity we just propagate all schemas, rather than litter pkgs/development/python-modules
  ++ lib.attrValues finalAttrs.passthru.schemas;

  optional-dependencies = {
    all = [ pyjwt ] ++ pyjwt.optional-dependencies.crypto;
    jwt = [ pyjwt ] ++ pyjwt.optional-dependencies.crypto;
    auth-app = [ pyjwt ] ++ pyjwt.optional-dependencies.crypto;
    auth-oauth-device = [ ];
    auth = [ pyjwt ] ++ pyjwt.optional-dependencies.crypto;
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "githubkit" ];

  disabledTests = [
    # Tests require network access
    "test_graphql"
    "test_async_graphql"
    "test_call"
    "test_async_call"
    "test_versioned_call"
    "test_versioned_async_call"
  ];

  meta = {
    description = "GitHub SDK for Python";
    homepage = "https://github.com/yanyongyu/githubkit";
    changelog = "https://github.com/yanyongyu/githubkit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
