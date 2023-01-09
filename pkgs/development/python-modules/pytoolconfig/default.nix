{ lib
, buildPythonPackage
, docutils
, fetchFromGitHub
, packaging
, pdm-pep517
, platformdirs
, pydantic
, pytest-timeout
, pytestCheckHook
, pythonOlder
, sphinx
, tabulate
, tomli
}:

buildPythonPackage rec {
  pname = "pytoolconfig";
  version = "1.2.5";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bagel897";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-b7er/IgXr2j9dSnI87669BXWA5CXNTzwa1DTpl8PBZ4=";
  };

  postPatch = ''
    # License file name doesn't match
    substituteInPlace pyproject.toml \
      --replace "license = { file = 'LGPL-3.0' }" "" \
      --replace 'dynamic = ["version"]' 'version = "${version}"' \
      --replace "packaging>=22.0" "packaging"
  '';

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = [
    packaging
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  passthru.optional-dependencies = {
    validation = [
      pydantic
    ];
    global = [
      platformdirs
    ];
    doc = [
      sphinx
      tabulate
    ];
  };

  checkInputs = [
    docutils
    pytestCheckHook
  ] ++ passthru.optional-dependencies.global
  ++ passthru.optional-dependencies.doc;

  pythonImportsCheck = [
    "pytoolconfig"
  ];

  meta = with lib; {
    description = "Module for tool configuration";
    homepage = "https://github.com/bagel897/pytoolconfig";
    changelog = "https://github.com/bagel897/pytoolconfig/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
