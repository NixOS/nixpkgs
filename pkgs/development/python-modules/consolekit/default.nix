{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, click
, deprecation-alias
, domdf-python-tools
, mistletoe
, typing-extensions
, psutil
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "consolekit";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "domdfcoding";
    repo = "consolekit";
    rev = "v${version}";
    hash = "sha256-vc8W3tf2jo8hhfnrmj0eKv8MuDCJcp2Dnz4dMyxRF8M=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    click
    deprecation-alias
    domdf-python-tools
    mistletoe
    typing-extensions
  ];

  passthru.optional-dependencies = {
    terminals = [
      psutil
    ];
  };

  pythonImportsCheck = [ "consolekit" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # requires coincidence which hasn't been packaged yet
  doCheck = false;

  meta = {
    description = "Additional utilities for click";
    homepage = "https://github.com/domdfcoding/consolekit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
