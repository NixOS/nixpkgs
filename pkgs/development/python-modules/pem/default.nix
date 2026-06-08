{
  lib,
  buildPythonPackage,
  certifi,
  cryptography,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  pretend,
  pyopenssl,
  pytestCheckHook,
  twisted,
}:

buildPythonPackage rec {
  pname = "pem";
  version = "23.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "pem";
    tag = version;
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
  ]
  ++ twisted.optional-dependencies.tls;

  pythonImportsCheck = [ "pem" ];

  meta = {
    description = "Easy PEM file parsing in Python";
    homepage = "https://pem.readthedocs.io/";
    changelog = "https://github.com/hynek/pem/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nyanotech ];
  };
}
