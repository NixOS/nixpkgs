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
<<<<<<< HEAD
  version = "1.21.0";
=======
  version = "1.20.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "LacusCore";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-q/JVvhI1NZTuX8vRWi/Q9ANE8ZTaTFNfb94n0NpH+/0=";
=======
    hash = "sha256-L7hmqNymXkZD/NQk1OQ9H34aJcCa6W23gkQSjomv7Iw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Modulable part of Lacus";
    homepage = "https://github.com/ail-project/LacusCore";
    changelog = "https://github.com/ail-project/LacusCore/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Modulable part of Lacus";
    homepage = "https://github.com/ail-project/LacusCore";
    changelog = "https://github.com/ail-project/LacusCore/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
