{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "urlscan";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = "urlscan";
    tag = finalAttrs.version;
    hash = "sha256-ToZ4rom/FZ5n8qWRpuFO78V8AB50n80BBPsqEg8d0c4=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [ urwid ];

  nativeCheckInputs = [
    versionCheckHook
  ]
  ++ (with python3Packages; [
    pytestCheckHook
  ]);

  pythonImportsCheck = [ "urlscan" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mutt and terminal url selector (similar to urlview)";
    homepage = "https://github.com/firecat53/urlscan";
    changelog = "https://github.com/firecat53/urlscan/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      dpaetzel
      lonerOrz
    ];
    mainProgram = "urlscan";
  };
})
