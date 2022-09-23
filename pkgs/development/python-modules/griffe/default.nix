{ lib
, aiofiles
, buildPythonApplication
, cached-property
, fetchFromGitHub
, git
, pdm-pep517
, pytestCheckHook
, pythonOlder
}:

buildPythonApplication rec {
  pname = "griffe";
  version = "0.22.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = pname;
    rev = version;
    hash = "sha256-GqPXVi+SsfO0ufUJzEZ5eUzwJmM/wylLA1KMv+WaIsU=";
  };

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    cached-property
  ];

  checkInputs = [
    git
    pytestCheckHook
  ];

  passthru.optional-dependencies = {
    async = [
      aiofiles
    ];
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  pythonImportsCheck = [
    "griffe"
  ];

  meta = with lib; {
    description = "Signatures for entire Python programs";
    homepage = "https://github.com/mkdocstrings/griffe";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
