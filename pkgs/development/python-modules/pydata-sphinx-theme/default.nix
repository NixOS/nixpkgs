{
  lib,
  buildPythonPackage,
  fetchPypi,
  sphinx,
  accessible-pygments,
  beautifulsoup4,
  docutils,
  packaging,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pydata-sphinx-theme";
  version = "0.16.1";

  format = "wheel";

  src = fetchPypi {
    inherit version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    pname = "pydata_sphinx_theme";
    hash = "sha256-IlMx6KxLMmgsGPysWlem9xfE5jLOpd0OJHtVFV+uzN4=";
  };

  propagatedBuildInputs = [
    sphinx
    accessible-pygments
    beautifulsoup4
    docutils
    packaging
    typing-extensions
  ];

  pythonImportsCheck = [ "pydata_sphinx_theme" ];

  meta = {
    description = "Bootstrap-based Sphinx theme from the PyData community";
    homepage = "https://github.com/pydata/pydata-sphinx-theme";
    changelog = "https://github.com/pydata/pydata-sphinx-theme/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
