{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  setuptools,
  wheel,
  cython,

  numpy,
  scipy,
  scikit-learn,
}:

buildPythonPackage rec {
  pname = "quantile-forest";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zillow";
    repo = "quantile-forest";
    tag = "v${version}";
    hash = "sha256-KNHp6/TUy7Aof3P4TNGpsRlNVePrHEc4HFvMqyr4gPg=";
  };

  build-system = [
    setuptools
    cython
    wheel
    numpy
    scipy
    scikit-learn
  ];

  dependencies = [
    numpy
    scipy
    scikit-learn
  ];

  postInstall = ''
    rm -rf $out/${python.sitePackages}/examples
  '';

  # need network connection
  doCheck = false;

  pythonImportsCheck = [ "quantile_forest" ];

  meta = {
    description = "Quantile Regression Forests compatible with scikit-learn";
    homepage = "https://github.com/zillow/quantile-forest";
    changelog = "https://github.com/zillow/quantile-forest/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vizid ];
  };
}
