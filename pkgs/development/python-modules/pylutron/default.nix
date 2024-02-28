{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "pylutron";
  version = "0.2.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UTn4HfyiyQAekIZD4I5lacYb7ySRhW8OUgiOg33JZtQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pylutron"
  ];

  meta = with lib; {
    changelog = "https://github.com/thecynic/pylutron/releases/tag/${version}";
    description = "Python library for controlling a Lutron RadioRA 2 system";
    homepage = "https://github.com/thecynic/pylutron";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
