{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  importlib-metadata,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  toml,
}:

buildPythonPackage rec {
  pname = "aiolimiter";
  version = "1.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mjpieters";
    repo = "aiolimiter";
    tag = "v${version}";
    hash = "sha256-wgHR0GzaPXlhL4ErklFqmWNFO49dvd5X5MgyYHVH4Eo=";
  };

  # ERROR: '"session"' is not a valid asyncio_default_fixture_loop_scope. Valid scopes are: function, class, module, package, session.
  # Post 1.2.1, the project switched from tox and is no longer affected, hence fixed in nixpkgs only.
  postPatch = ''
    substituteInPlace tox.ini --replace-fail \
      'asyncio_default_fixture_loop_scope = "session"' \
      'asyncio_default_fixture_loop_scope = session'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    toml
  ];

  pythonImportsCheck = [ "aiolimiter" ];

  meta = with lib; {
    description = "Implementation of a rate limiter for asyncio";
    homepage = "https://github.com/mjpieters/aiolimiter";
    changelog = "https://github.com/mjpieters/aiolimiter/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
