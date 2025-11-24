{
  lib,
  python3,
  fetchFromGitHub,
  unstableGitUpdater,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zeekscript";
  version = "1.3.2-unstable-2025-11-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "zeekscript";
    rev = "7f3d41b495cc87ee0db5cc90ccd0f5c9a23487df";
    hash = "sha256-IpoDSLPDF2p/Yuijb3xtvs1zivtYrKny/pY5dRL56QA=";
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
