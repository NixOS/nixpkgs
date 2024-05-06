{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
}:

buildPythonPackage rec {
  pname = "pyrate-limiter";
  version = "3.6.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "vutran1710";
    repo = "PyrateLimiter";
    rev = "refs/tags/v${version}";
    hash = "sha256-uOUvKC+rXzaZfV6lsbsK1WdDGnPjr4HeFDCjNXDWHpw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonImportsCheck = [
    "pyrate_limiter"
  ];

  # The only consumer of this is Lutris (via python-moddb), and it requires 2.x,
  # so don't auto-update it and break Lutris every python-updates.
  # FIXME: remove when python-moddb updates.
  passthru.skipBulkUpdate = true;

  meta = with lib; {
    description = "Python Rate-Limiter using Leaky-Bucket Algorimth Family";
    homepage = "https://github.com/vutran1710/PyrateLimiter";
    changelog = "https://github.com/vutran1710/PyrateLimiter/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
