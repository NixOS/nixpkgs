{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  importlib-metadata,
  pytest-asyncio,
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
    repo = pname;
    tag = "v${version}";
    hash = "sha256-wgHR0GzaPXlhL4ErklFqmWNFO49dvd5X5MgyYHVH4Eo=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    toml
  ];

  postPatch = ''
    substituteInPlace tox.ini \
      --replace " --cov=aiolimiter --cov-config=tox.ini --cov-report term-missing" ""
  '';

  pythonImportsCheck = [ "aiolimiter" ];

  meta = with lib; {
    description = "Implementation of a rate limiter for asyncio";
    homepage = "https://github.com/mjpieters/aiolimiter";
    changelog = "https://github.com/mjpieters/aiolimiter/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
