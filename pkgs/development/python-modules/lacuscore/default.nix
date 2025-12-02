{
  lib,
  async-timeout,
  buildPythonPackage,
  defang,
  dnspython,
  eval-type-backport,
  fetchFromGitHub,
  orjson,
  playwrightcapture,
  poetry-core,
  pydantic,
  pythonOlder,
  redis,
  requests,
  ua-parser,
}:

buildPythonPackage rec {
  pname = "lacuscore";
  version = "1.20.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "LacusCore";
    tag = "v${version}";
    hash = "sha256-L7hmqNymXkZD/NQk1OQ9H34aJcCa6W23gkQSjomv7Iw=";
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
  ++ ua-parser.optional-dependencies.regex
  ++ lib.optionals (pythonOlder "3.11") [ async-timeout ]
  ++ lib.optionals (pythonOlder "3.10") [ eval-type-backport ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "lacuscore" ];

  meta = with lib; {
    description = "Modulable part of Lacus";
    homepage = "https://github.com/ail-project/LacusCore";
    changelog = "https://github.com/ail-project/LacusCore/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
