{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "vermin";
  version = "1.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netromdk";
    repo = "vermin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XOruR+/9Ujoz6Pa7v6ux6aw4+mkNhlY+sldSttxhjeo=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    setuptools
  ];

  checkPhase = ''
    runHook preCheck
    python runtests.py
    runHook postCheck
  '';

  meta = {
    mainProgram = "vermin";
    homepage = "https://github.com/netromdk/vermin";
    changelog = "https://github.com/netromdk/vermin/releases/tag/v${finalAttrs.version}";
    description = "Concurrently detect the minimum Python versions needed to run code";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.fidgetingbits ];
  };
})
