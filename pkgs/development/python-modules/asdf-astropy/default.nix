{
  lib,
  asdf-coordinates-schemas,
  asdf-standard,
  asdf-transform-schemas,
  asdf,
  astropy,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  packaging,
  pytest-astropy,
  pytestCheckHook,
  pythonOlder,
  scipy,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asdf-astropy";
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "astropy";
    repo = "asdf-astropy";
    tag = version;
    hash = "sha256-hP77qhNTE89cuz9Z8vWlWYo2En0SV4uoHaBnxQDNEvI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asdf
    asdf-coordinates-schemas
    asdf-standard
    asdf-transform-schemas
    astropy
    numpy
    packaging
  ];

  nativeCheckInputs = [
    pytest-astropy
    pytestCheckHook
    scipy
  ];

  pythonImportsCheck = [ "asdf_astropy" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Extension library for ASDF to provide support for Astropy";
    homepage = "https://github.com/astropy/asdf-astropy";
    changelog = "https://github.com/astropy/asdf-astropy/blob/${src.tag}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
