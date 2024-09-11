{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  packaging,
  tenacity,
  kaleido,
}:

buildPythonPackage rec {
  pname = "plotly";
  version = "5.24.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "plotly.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-frSUybQxst4wG8g8U43Nay9dYCUXuR3dBealwPVyFdI=";
  };

  postPatch = ''
    cd packages/python/plotly

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
