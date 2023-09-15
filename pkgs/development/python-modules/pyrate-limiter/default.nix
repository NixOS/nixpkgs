{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
}:

buildPythonPackage rec {
  pname = "pyrate-limiter";
  version = "3.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "vutran1710";
    repo = "PyrateLimiter";
    rev = "refs/tags/v${version}";
    hash = "sha256-WL+nNk68NaK36Lwalj23ugiSuB5acSLumLJGQaXE06A=";
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
