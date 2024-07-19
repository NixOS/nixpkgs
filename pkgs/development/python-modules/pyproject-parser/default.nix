{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, apeye-core
, attrs
, dom-toml
, domdf-python-tools
, natsort
, packaging
, shippinglabel
, toml
, tomli
, typing-extensions
, click
, consolekit
#, sdjson
, docutils
, readme-renderer
, pytest-regressions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyproject-parser";
  version = "0.9.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "repo-helper";
    repo = "pyproject-parser";
    rev = "v${version}";
    hash = "sha256-9poW60WTDPd573hVO1PF7WID/SbniQm3nWnL/cO7XNo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    apeye-core
    attrs
    dom-toml
    domdf-python-tools
    natsort
    packaging
    shippinglabel
    toml
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  passthru.optional-dependencies = {
    all = lib.flatten (lib.attrValues (lib.filterAttrs (n: v: n != "all") passthru.optional-dependencies));
    cli = [
      click
      consolekit
      #sdjson
    ];
    readme = [
      docutils
      readme-renderer
    ];
  };

  pythonImportsCheck = [ "pyproject_parser" ];

  nativeCheckInputs = [
    pytest-regressions
    pytestCheckHook
  ];

  # requires coincidence which hasn't been packaged yet
  doCheck = false;

  meta = {
    description = "Parser for 'pyproject.toml'";
    homepage = "https://github.com/repo-helper/pyproject-parser";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
