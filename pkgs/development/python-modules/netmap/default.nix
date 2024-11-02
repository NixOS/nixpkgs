{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  substituteAll,
  nmap,
  python,
}:

buildPythonPackage rec {
  pname = "netmap";
  version = "0.7.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "python-nmap";
    rev = version;
    sha256 = "1a44zz9zsxy48ahlpjjrddpyfi7cnfknicfcp35hi588qm430mag";
  };

  patches = [
    (substituteAll {
      src = ./nmap-path.patch;
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

  meta = with lib; {
    description = "Python class to use nmap and access scan results from python3";
    homepage = "https://github.com/home-assistant-libs/python-nmap";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
