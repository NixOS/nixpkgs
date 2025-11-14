{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  toml,
}:

buildPythonPackage rec {
  pname = "aiolimiter";
  version = "1.2.1";
  pyproject = true;

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

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    toml
  ];

  pythonImportsCheck = [ "aiolimiter" ];

  meta = {
    description = "Implementation of a rate limiter for asyncio";
    homepage = "https://github.com/mjpieters/aiolimiter";
    changelog = "https://github.com/mjpieters/aiolimiter/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
