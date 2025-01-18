{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  apeye-core,
  attrs,
  dom-toml,
  domdf-python-tools,
  natsort,
  packaging,
  shippinglabel,
  typing-extensions,
}:
buildPythonPackage rec {
  pname = "pyproject-parser";
  version = "0.11.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0ejtu6OlSA6w/z/+j2lDuikFGZh4r/HLBZhJAKZhggE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    apeye-core
    attrs
    dom-toml
    domdf-python-tools
    natsort
    packaging
    shippinglabel
    typing-extensions
  ];
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools!=61.*,<=67.1.0,>=40.6.0"' '"setuptools"'
  '';

  meta = with lib; {
    description = "Parser for ‘pyproject.toml’";
    homepage = "https://github.com/repo-helper/pyproject-parser";
    license = licenses.mit;
    maintainers = with maintainers; [ tyberius-prime ];
  };
}
