{
  lib,
  async-timeout,
  buildPythonPackage,
  defang,
  dnspython,
  fetchFromGitHub,
  playwrightcapture,
  poetry-core,
  pydantic,
  pythonOlder,
  redis,
  requests,
  sphinx,
  ua-parser,
}:

buildPythonPackage rec {
  pname = "lacuscore";
  version = "1.12.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "LacusCore";
    rev = "refs/tags/v${version}";
    hash = "sha256-iozCgQ7VULQVlKaHmThxiFDZ2hly2yYMdIrXBFHFRfI=";
  };

  pythonRelaxDeps = [
    "pydantic"
    "redis"
    "requests"
  ];

  build-system = [ poetry-core ];


  dependencies = [
    async-timeout
    defang
    dnspython
    playwrightcapture
    pydantic
    redis
    requests
    sphinx
    ua-parser
  ];

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
