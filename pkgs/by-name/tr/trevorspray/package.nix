{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "trevorspray";
  version = "2.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2kprXyZUAe8lBV48mBpmkhBtOoxgrP/TOTdS3Kw2WTE=";
  };

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    exchangelib
    mechanicalsoup
    pygments
    pysocks
    sh
    tldextract
    trevorproxy
  ];

  meta = {
    description = "Modular password spraying tool";
    homepage = "https://github.com/blacklanternsecurity/TREVORspray";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "trevorspray";
  };
}
