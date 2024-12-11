{
  lib,
  async-timeout,
  buildPythonPackage,
  defang,
  dnspython,
  eval-type-backport,
  fetchFromGitHub,
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
  version = "1.12.6";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "LacusCore";
    rev = "refs/tags/v${version}";
    hash = "sha256-KiYpPgwMsIuIDUjQfw83ATiE5VI2XMaxGsnP5xEypqc=";
  };

  pythonRelaxDeps = [
    "pydantic"
    "redis"
    "requests"
  ];

  build-system = [ poetry-core ];

  dependencies =
    [
      defang
      dnspython
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
    changelog = "https://github.com/ail-project/LacusCore/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
