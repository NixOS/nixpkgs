{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  nmap,
  python,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "netmap";
  version = "0.7.0.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "python-nmap";
    tag = finalAttrs.version;
    sha256 = "1a44zz9zsxy48ahlpjjrddpyfi7cnfknicfcp35hi588qm430mag";
  };

  build-system = [
    setuptools
  ];

  patches = [
    (replaceVars ./nmap-path.patch {
      nmap = "${lib.getBin nmap}/bin/nmap";
    })
  ];

  # upstream tests require sudo
  # make sure nmap is found instead
  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -c 'import nmap; nmap.PortScanner()'
    runHook postCheck
  '';

  pythonImportsCheck = [ "nmap" ];

  meta = {
    description = "Python class to use nmap and access scan results from python3";
    homepage = "https://github.com/home-assistant-libs/python-nmap";
    changelog = "https://github.com/home-assistant-libs/python-nmap/blob/${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
