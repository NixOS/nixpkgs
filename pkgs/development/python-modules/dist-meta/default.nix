{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  domdf-python-tools,
  handy-archives,
  packaging,
}:
buildPythonPackage rec {
  pname = "dist-meta";
  version = "0.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5zuHOwg2GDXiVZLU10Ep8DU7ykRR3RK/oQqvFK9GguQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    domdf-python-tools
    handy-archives
    packaging
  ];

  nativeCheckInputs = [ ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools!=61.*,<=67.1.0,>=40.6.0"' '"setuptools"'
  '';

  meta = {
    description = "Parse and create Python distribution metadata.";
    homepage = "https://github.com/repo-helper/dist-meta";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
