{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pyrate-limiter";
  version = "3.7.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "vutran1710";
    repo = "PyrateLimiter";
    tag = "v${version}";
    hash = "sha256-oNwFxH75TJm0iJSbLIO8SlIih72ImlHIhUW7GjOEorw=";
  };

  nativeBuildInputs = [ poetry-core ];

  pythonImportsCheck = [ "pyrate_limiter" ];

  # The only consumer of this is Lutris (via python-moddb), and it requires 2.x,
  # so don't auto-update it and break Lutris every python-updates.
  # FIXME: remove when python-moddb updates.
  passthru.skipBulkUpdate = true;

  meta = with lib; {
    description = "Python Rate-Limiter using Leaky-Bucket Algorimth Family";
    homepage = "https://github.com/vutran1710/PyrateLimiter";
    changelog = "https://github.com/vutran1710/PyrateLimiter/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
