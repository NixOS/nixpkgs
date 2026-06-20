{
  lib,
  python3,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "xnldorker";
  version = "4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xnl-h4ck3r";
    repo = "xnldorker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2Oh341KTxD47aZVTikDMFs6e4HGfQ77BPptksw+6w7s=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    playwright
    pyyaml
    requests
    termcolor
    tldextract
    urllib3
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "xnldorker" ];

  meta = {
    description = "Gather results of dorks across a number of search engines";
    homepage = "https://github.com/xnl-h4ck3r/xnldorker";
    changelog = "https://github.com/xnl-h4ck3r/xnldorker/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "xnldorker";
  };
})
