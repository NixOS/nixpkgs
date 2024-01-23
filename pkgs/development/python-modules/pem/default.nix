{ lib
, buildPythonPackage
, certifi
, cryptography
, fetchFromGitHub
, hatch-fancy-pypi-readme
, hatch-vcs
, hatchling
, pretend
, pyopenssl
, pytestCheckHook
, pythonOlder
, twisted
}:

buildPythonPackage rec {
  pname = "pem";
  version = "23.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hynek";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-rVYlnvISGugh9qvf3mdrIyELmeOUU4g6291HeoMkoQc=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-fancy-pypi-readme
    hatch-vcs
  ];

  nativeCheckInputs = [
    certifi
    cryptography
    pretend
    pyopenssl
    pytestCheckHook
    twisted
  ] ++ twisted.optional-dependencies.tls;

  pythonImportsCheck = [
    "pem"
  ];

  meta = with lib; {
    description = "Easy PEM file parsing in Python";
    homepage = "https://pem.readthedocs.io/";
    changelog = "https://github.com/hynek/pem/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanotech ];
  };
}
