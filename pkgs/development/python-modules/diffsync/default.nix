{ lib
, buildPythonPackage
, colorama
, fetchFromGitHub
, packaging
, poetry-core
, pydantic
, pythonRelaxDepsHook
, redis
, structlog
}:

buildPythonPackage rec {
  pname = "diffsync";
  version = "2.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "networktocode";
    repo = "diffsync";
    rev = "refs/tags/v${version}";
    hash = "sha256-4LS18FPrnGE1tM0pFzAw0+ajDaw9g7MCgIwS2ptrX9c=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "packaging"
    "structlog"
  ];

  propagatedBuildInputs = [
    colorama
    packaging
    pydantic
    redis
    structlog
  ];

  pythonImportsCheck = [
    "diffsync"
  ];

  meta = with lib; {
    description = "Utility library for comparing and synchronizing different datasets";
    homepage = "https://github.com/networktocode/diffsync";
    changelog = "https://github.com/networktocode/diffsync/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ clerie ];
  };
}
