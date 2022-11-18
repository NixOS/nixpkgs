{ lib
, aiofiles
, buildPythonPackage
, cached-property
, colorama
, fetchFromGitHub
, git
, pdm-pep517
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "griffe";
  version = "0.24.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = pname;
    rev = version;
    hash = "sha256-Gcht9pmh15dvSHRsG9y82l4HoJ7l/gxbmrRh7Jow2Bs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"' \
      --replace 'license = "ISC"' 'license = {file = "LICENSE"}' \
      --replace 'version = {source = "scm"}' 'license-expression = "ISC"'
  '';

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = [
    colorama
  ] ++ lib.optionals (pythonOlder "3.8") [
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
