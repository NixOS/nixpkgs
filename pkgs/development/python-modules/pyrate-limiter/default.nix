{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
}:

buildPythonPackage rec {
  pname = "pyrate-limiter";
  version = "3.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "vutran1710";
    repo = "PyrateLimiter";
    rev = "refs/tags/v${version}";
    hash = "sha256-EBgeLBIyiveY9GTdwl93bX9JOCffREU4W8C0fx7zXeE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonImportsCheck = [
    "pyrate_limiter"
  ];

  meta = with lib; {
    description = "Python Rate-Limiter using Leaky-Bucket Algorimth Family";
    homepage = "https://github.com/vutran1710/PyrateLimiter";
    changelog = "https://github.com/vutran1710/PyrateLimiter/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
