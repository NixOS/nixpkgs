{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  ifaddr,
  mcp,
  nix-update-script,
  pydantic,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  python-libpcap,
  pyyaml,
  rdflib,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "bacpypes3";
  version = "0.0.108";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JoelBender";
    repo = "bacpypes3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tl4lbIW2ADYtDcYLOocy0nmW5t04JKAfmbHyESPZiW0=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  optional-dependencies = {
    ifaddr = [ ifaddr ];
    mcp = [
      mcp
      pydantic
    ];
    pylibpcap = [ python-libpcap ];
    rdflib = [ rdflib ];
    websockets = [ websockets ];
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "bacpypes3" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "BACnet communications library";
    homepage = "https://github.com/JoelBender/bacpypes3";
    changelog = "https://github.com/JoelBender/bacpypes3/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
