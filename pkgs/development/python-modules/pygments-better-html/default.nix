{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pygments,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygments-better-html";
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kwpolska";
    repo = "pygments_better_html";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7vX/xm1lb89YLuDJmgdDCg+/UHinQAchi8OaF9TXRJA=";
  };

  build-system = [ flit-core ];

  dependencies = [ pygments ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} demo.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "pygments_better_html" ];

  meta = {
    changelog = "https://github.com/Kwpolska/pygments_better_html/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    homepage = "https://github.com/Kwpolska/pygments_better_html";
    description = "Improved line numbering for Pygments’ HTML formatter";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
