{
  lib,
  buildPythonPackage,
  defang,
  dnspython,
  fetchFromGitHub,
  orjson,
  playwrightcapture,
  poetry-core,
  pydantic,
  redis,
  requests,
  ua-parser,
}:

buildPythonPackage rec {
  pname = "lacuscore";
  version = "1.21.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "LacusCore";
    tag = "v${version}";
    hash = "sha256-I6Qh7AzcTYDxNmvgTNVVPSenLfAbdLawdiN8JrrF25s=";
  };

  pythonRelaxDeps = [
    "dnspython"
    "orjson"
    "pydantic"
    "redis"
    "requests"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    defang
    dnspython
    orjson
    playwrightcapture
    pydantic
    redis
    requests
    ua-parser
  ]
  ++ playwrightcapture.optional-dependencies.recaptcha
  ++ redis.optional-dependencies.hiredis
  ++ ua-parser.optional-dependencies.regex;

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "lacuscore" ];

  meta = {
    description = "Modulable part of Lacus";
    homepage = "https://github.com/ail-project/LacusCore";
    changelog = "https://github.com/ail-project/LacusCore/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
