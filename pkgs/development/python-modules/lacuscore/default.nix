{
  lib,
  async-timeout,
  buildPythonPackage,
  defang,
  dnspython,
  fetchFromGitHub,
  playwrightcapture,
  poetry-core,
  pythonOlder,
  redis,
  requests,
  pythonRelaxDepsHook,
  sphinx,
  ua-parser,
}:

buildPythonPackage rec {
  pname = "lacuscore";
  version = "1.9.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "LacusCore";
    rev = "refs/tags/v${version}";
    hash = "sha256-SCObCYcZ+aDzWOkE5tzkKMkgAP/h7HDNyHXMFmYjiHQ=";
  };

  pythonRelaxDeps = [
    "redis"
    "requests"
  ];

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  dependencies = [
    async-timeout
    defang
    dnspython
    playwrightcapture
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
