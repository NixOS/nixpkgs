{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitMinimal,
  hatchling,
  hypothesis,
  nab-index,
  nab-markersets,
  nab-project,
  nab-provider,
  nab-resolver,
  pytestCheckHook,
  pytest-timeout,
  pytest-xdist,
  respx,
  tomli,
  tomlkit,
  typing-extensions,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "nab";
  version = "0.0.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "notatallshaw";
    repo = "nab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6HiGIiwmccCVC/JUISHytotVLI5Np6U8VlN5nR0GoG0=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ hatchling ];

  dependencies = [
    nab-index
    nab-markersets
    nab-project
    nab-provider
    nab-resolver
    tomli
    typing-extensions
  ];

  optional-dependencies = {
    inherit (nab-index.optional-dependencies) httpx httpx2;
  };

  nativeCheckInputs = [
    gitMinimal
    hypothesis
    pytestCheckHook
    pytest-timeout
    pytest-xdist
    respx
    tomlkit
    versionCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  makeWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath [ gitMinimal ])
  ];

  pythonImportsCheck = [ "nab" ];

  meta = {
    description = "PubGrub-based dependency resolver for Python packages";
    homepage = "https://github.com/notatallshaw/nab";
    changelog = "https://github.com/notatallshaw/nab/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mdaniels5757 ];
    mainProgram = "nab";
  };
})
