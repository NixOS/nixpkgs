{
  lib,
  python3,
  fetchFromGitHub,
  unstableGitUpdater,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zeekscript";
  version = "1.3.2-unstable-2025-12-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "zeekscript";
    rev = "3c29e0cd6f948faa4fd398ad4ae31a25b6905748";
    hash = "sha256-Vjmg+u6oJFhFuaSZ/5Dhj4oy1t0MNA2VuYOxQY0oENw=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    argcomplete
    tree-sitter
    tree-sitter-zeek
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-cov-stub
  ];

  checkInputs = with python3.pkgs; [ syrupy ];

  pythonImportsCheck = [
    "zeekscript"
  ];

  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = {
    description = "Zeek script formatter and analyzer";
    homepage = "https://github.com/zeek/zeekscript";
    changelog = "https://github.com/zeek/zeekscript/blob/${src.rev}/CHANGES";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      fab
      tobim
      mdaniels5757
    ];
  };
}
