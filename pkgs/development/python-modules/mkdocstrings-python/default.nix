{ lib
, buildPythonApplication
, fetchFromGitHub
, griffe
, mkdocs-material
, mkdocstrings
, pdm-pep517
, pytestCheckHook
, pythonOlder
}:

buildPythonApplication rec {
  pname = "mkdocstrings-python";
  version = "0.7.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "python";
    rev = version;
    hash = "sha256-cZk6Eu6Jp3tSPAb0HplR/I0pX2YIFhOaAsI3YRS0LVw=";
  };

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = [
    griffe
    mkdocstrings
  ];

  checkInputs = [
    mkdocs-material
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  pythonImportsCheck = [
    "mkdocstrings_handlers"
  ];

  meta = with lib; {
    description = "Python handler for mkdocstrings";
    homepage = "https://github.com/mkdocstrings/python";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
