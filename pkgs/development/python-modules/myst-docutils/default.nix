{ lib
, buildPythonPackage
, docutils
, fetchPypi
, flit-core
, jinja2
, markdown-it-py
, mdit-py-plugins
, pythonOlder
, pyyaml
, typing-extensions
}:

buildPythonPackage rec {
  pname = "myst-docutils";
  version = "0.18.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-evyIuNLbBWR3KfQMv2lNw6fOgX1+/uMS5cHIbSTYDmA=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    docutils
    jinja2
    markdown-it-py
    mdit-py-plugins
    pyyaml
    typing-extensions
  ];

  pythonImportsCheck = [ "myst_parser" ];

  meta = with lib; {
    description = "An extended commonmark compliant parser, with bridges to docutils/sphinx.";
    homepage = "https://github.com/executablebooks/MyST-Parser";
    license = licenses.mit;
    maintainers = with maintainers; [ dpausp ];
    broken = pythonOlder "3.8"; # dependency networkx requires 3.8
  };
}
