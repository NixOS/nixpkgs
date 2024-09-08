{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  packaging,
  tenacity,
  kaleido,
}:

buildPythonPackage rec {
  pname = "plotly";
  version = "5.23.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ieV9ADoRYwOjTeZwCGI5E2fdVkIiq3H4Ux33Ann8AZM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "\"jupyterlab~=3.0;python_version>='3.6'\"," ""
  '';

  env.SKIP_NPM = true;

  build-system = [ setuptools ];

  dependencies = [
    packaging
    tenacity
    kaleido
  ];

  pythonImportsCheck = [ "plotly" ];

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Python plotting library for collaborative, interactive, publication-quality graphs";
    downloadPage = "https://github.com/plotly/plotly.py";
    homepage = "https://plot.ly/python/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ pandapip1 ];
  };
}
