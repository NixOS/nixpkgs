{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, sphinx
, accessible-pygments
, beautifulsoup4
, docutils
, packaging
}:

buildPythonPackage rec {
  pname = "pydata-sphinx-theme";
  version = "0.13.0rc6";

  format = "wheel";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version format;
    dist = "py3";
    python = "py3";
    pname = "pydata_sphinx_theme";
    sha256 = "sha256-0JrTt5ZPbaEtqn9KbbAFfDjU3/6wAzbcbdAouv5o02I=";
  };

  propagatedBuildInputs = [
    sphinx
    accessible-pygments
    beautifulsoup4
    docutils
    packaging
  ];

  pythonImportsCheck = [
    "pydata_sphinx_theme"
  ];

  meta = with lib; {
    description = "Bootstrap-based Sphinx theme from the PyData community";
    homepage = "https://github.com/pydata/pydata-sphinx-theme";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marsam ];
  };
}
