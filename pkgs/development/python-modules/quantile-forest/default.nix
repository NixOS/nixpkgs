{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,

  setuptools,
  wheel,
  cython,

  numpy,
  scipy,
  scikit-learn,
}:

buildPythonPackage rec {
  pname = "quantile-forest";
  version = "1.3.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zillow";
    repo = "quantile-forest";
    rev = "refs/tags/v${version}";
    hash = "sha256-hzLJq0y+qjc48PfHW3i73x9safGOy0V1HEQ5WR8IXpI=";
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

  meta = with lib; {
    description = "Quantile Regression Forests compatible with scikit-learn";
    homepage = "https://github.com/zillow/quantile-forest";
    changelog = "https://github.com/zillow/quantile-forest/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ vizid ];
  };
}
