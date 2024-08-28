{
  lib,
  fetchFromGitHub,
  pythonAtLeast,
  buildPythonPackage,
  importlib-resources,
  pyyaml,
  requests,
  setuptools-scm,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "scikit-hep-testdata";
  version = "0.4.47";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "scikit-hep-testdata";
    rev = "refs/tags/v${version}";
    hash = "sha256-YCzqAe+TVNbPrHPxD/OjxkjmYCb5pZO0+l68xUJp72w=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    pyyaml
    requests
  ] ++ lib.optionals (!pythonAtLeast "3.9") [ importlib-resources ];

  SKHEP_DATA = 1; # install the actual root files

  doCheck = false; # tests require networking

  pythonImportsCheck = [ "skhep_testdata" ];

  meta = with lib; {
    homepage = "https://github.com/scikit-hep/scikit-hep-testdata";
    description = "Common package to provide example files (e.g., ROOT) for testing and developing packages against";
    changelog = "https://github.com/scikit-hep/scikit-hep-testdata/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
