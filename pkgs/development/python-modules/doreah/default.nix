{ lib, buildPythonPackage, fetchPypi, lxml, beautifulsoup4, jinja2, pyyaml, requests, MechanicalSoup, parse }:

buildPythonPackage rec {
  pname = "doreah";
  version = "1.7.2";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    dist = "py3";
    python = "py3";
    sha256 = "sha256-0gP06ZgKAjHFnYvVkmH9tID7SyMapyg9+O6QP9Xac9Q=";
  };

  propagatedBuildInputs = [ lxml beautifulsoup4 jinja2 pyyaml requests MechanicalSoup parse ];

  pythonImportsCheck = [ "doreah" ];

  meta = with lib; {
    description = "Personal package of helpful utilities";
    homepage = "https://github.com/krateng/doreah/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sohalt ];
  };
}
