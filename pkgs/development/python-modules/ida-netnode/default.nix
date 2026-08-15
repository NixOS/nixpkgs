{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  setuptools,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "ida-netnode";
  version = "3.0.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = "ida-netnode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hXApNeeDYHX41zuYDpSNqSXdM/c8DoVXuB6NMqYf7iU=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  # Module has no test and requires IDA to be installed
  doCheck = false;

  # pythonImportsCheck = [ "netnode"];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Humane API for storing and accessing persistent data in IDA Pro databases";
    homepage = "https://github.com/williballenthin/ida-netnode";
    changelog = "https://github.com/williballenthin/ida-netnode/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
