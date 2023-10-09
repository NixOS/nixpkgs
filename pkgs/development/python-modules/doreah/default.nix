{ lib, buildPythonPackage, fetchPypi, flit-core
, beautifulsoup4, jinja2, lxml, mechanicalsoup, pyyaml, requests
}:

buildPythonPackage rec {
  pname = "doreah";
  version = "1.9.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zl84SJJV4ne6AeJgUtxkSQnnV5FyG36zbuBLS7YhtnY=";
  };

  nativeBuildInputs = [
    flit-core
  ];
  propagatedBuildInputs = [
    beautifulsoup4
    jinja2
    lxml
    mechanicalsoup
    pyyaml
    requests
  ];

  meta = with lib; {
    homepage = "https://github.com/krateng/doreah";
    description = "A collection of useful tools used in krateng's Python projects";
    license = licenses.gpl3;
    maintainers = with maintainers; [ avh4 ];
  };
}
