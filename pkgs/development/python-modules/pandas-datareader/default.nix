{
  lib,
  buildPythonPackage,
  fetchPypi,
  lxml,
  pandas,
  requests,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pandas-datareader";
  version = "0.11.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pandas_datareader";
    inherit (finalAttrs) version;
    hash = "sha256-4erbbSzKpLeodqHIG2/wMH+noItW93mYYqUCB8LmWgU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools_scm>=8,<9" "setuptools_scm"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pandas
    lxml
    requests
  ];

  # Tests are trying to load data over the network
  doCheck = false;

  pythonImportsCheck = [ "pandas_datareader" ];

  meta = {
    description = "Up to date remote data access for pandas, works for multiple versions of pandas";
    homepage = "https://github.com/pydata/pandas-datareader";
    changelog = "https://github.com/pydata/pandas-datareader/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ evax ];
    platforms = lib.platforms.unix;
  };
})
