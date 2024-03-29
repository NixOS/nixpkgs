{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pylacus";
  version = "1.8.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "PyLacus";
    rev = "refs/tags/v${version}";
    hash = "sha256-wXdQe/4Xw/D0MRFqNfSKimJ99aCE7M7k1neT/+t7ixY=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    requests
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [
    "pylacus"
  ];

  meta = with lib; {
    description = "Module to enqueue and query a remote Lacus instance";
    homepage = "https://github.com/ail-project/PyLacus";
    changelog = "https://github.com/ail-project/PyLacus/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
