{
  buildPythonPackage,
  cached-property,
  click,
  coloredlogs,
  construct,
  fetchFromGitHub,
  lib,
  plumbum,
  pyimg4,
  remotezip2,
  requests,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "ipsw-parser";
  version = "1.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "doronz88";
    repo = "ipsw_parser";
    tag = "v${version}";
    hash = "sha256-B9T7c2xzUrzh5BxS7b3rpmPcUDT8Qmb4/5XTMfrOcR8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    cached-property
    click
    coloredlogs
    construct
    plumbum
    pyimg4
    remotezip2
    requests
  ];

  pythonImportsCheck = [ "ipsw_parser" ];

  checkPhase = ''
    runHook preCheck

    "$out"/bin/${meta.mainProgram} --help

    runHook postCheck
  '';

  meta = {
    changelog = "https://github.com/doronz88/ipsw_parser/releases/tag/${src.tag}";
    description = "Python3 utility for parsing and extracting data from IPSW";
    homepage = "https://github.com/doronz88/ipsw_parser";
    license = lib.licenses.gpl3Plus;
    mainProgram = "ipsw-parser";
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
