{
  backports-zstd,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  lib,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyzstd";
  version = "0.19.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Rogdham";
    repo = "pyzstd";
    tag = finalAttrs.version;
    hash = "sha256-1oUqnZCBJYu8haFIQ+T2KaSQaa1xnZyJHLzOQg4Fdw8=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies =
    lib.optionals (pythonOlder "3.13") [
      typing-extensions
    ]
    ++ lib.optionals (pythonOlder "3.14") [
      backports-zstd
    ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyzstd"
  ];

  meta = {
    description = "Python bindings to Zstandard (zstd) compression library";
    homepage = "https://pyzstd.readthedocs.io";
    changelog = "https://github.com/Rogdham/pyzstd/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      MattSturgeon
      pitkling
      PopeRigby
    ];
  };
})
