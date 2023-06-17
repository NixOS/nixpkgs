{ lib
, fetchFromGitHub
, pythonAtLeast
, buildPythonPackage
, importlib-resources
, pyyaml
, requests
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "scikit-hep-testdata";
  version = "0.4.30";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-8nmzU+aCBlGZs0O3/7gcP9zDM9LyCb6hVqW4cNKxrU4=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pyyaml
    requests
  ] ++ lib.optionals (!pythonAtLeast "3.9") [
    importlib-resources
  ];

  SKHEP_DATA = 1; # install the actual root files

  doCheck = false; # tests require networking

  pythonImportsCheck = [
    "skhep_testdata"
  ];

  meta = with lib; {
    homepage = "https://github.com/scikit-hep/scikit-hep-testdata";
    description = "A common package to provide example files (e.g., ROOT) for testing and developing packages against";
    changelog = "https://github.com/scikit-hep/scikit-hep-testdata/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
