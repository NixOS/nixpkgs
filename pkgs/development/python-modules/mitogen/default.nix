{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "mitogen";
  version = "0.3.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mitogen-hq";
    repo = "mitogen";
    rev = "refs/tags/v${version}";
    hash = "sha256-EDybx25eqJiMeoyB/lkuuofGTS8Q0ZjtB8HaKuGaKhk=";
  };

  build-system = [
    setuptools
  ];

  # Tests require network access and Docker support
  doCheck = false;

  pythonImportsCheck = [
    "mitogen"
  ];

  meta = with lib; {
    description = "Python Library for writing distributed self-replicating programs";
    homepage = "https://github.com/mitogen-hq/mitogen";
    changelog = "https://github.com/mitogen-hq/mitogen/blob/v${version}/docs/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
