{ lib
, argcomplete
, buildPythonPackage
, colorlog
, fetchFromGitHub
, fetchpatch
, setuptools
, importlib-metadata
, jinja2
, packaging
, pytestCheckHook
, pythonOlder
, tox
, typing-extensions
, virtualenv
}:

buildPythonPackage rec {
  pname = "nox";
  version = "2022.11.21";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wntrblm";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-N70yBZyrtdQvgaJzkskG3goHit8eH0di9jHycuAwzfU=";
  };

  patches = [
    # Remove rogue mocking of py._path, https://github.com/wntrblm/nox/pull/677
    (fetchpatch {
      name = "remove-py-pyth.patch";
      url = "https://github.com/wntrblm/nox/commit/44d06b679761e21d76bb96b2b8ffe0ffbe3d4fd0.patch";
      hash = "sha256-KRDVwbBMBd4GdiAcGJyS7DTNUw3Pumt0JO1igx6npnc=";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    argcomplete
    colorlog
    packaging
    virtualenv
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
    importlib-metadata
  ];


  checkInputs = [
    jinja2
    tox
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nox"
  ];

  disabledTestPaths = [
    # AttributeError: module 'tox.config' has...
    "tests/test_tox_to_nox.py"
  ];

  meta = with lib; {
    description = "Flexible test automation for Python";
    homepage = "https://nox.thea.codes/";
    changelog = "https://github.com/wntrblm/nox/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar fab ];
  };
}
