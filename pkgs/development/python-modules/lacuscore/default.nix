{ lib
, async-timeout
, buildPythonPackage
, defang
, dnspython
, fetchFromGitHub
, playwrightcapture
, poetry-core
, pythonOlder
, redis
, requests
, pythonRelaxDepsHook
, sphinx
, ua-parser
}:

buildPythonPackage rec {
  pname = "lacuscore";
  version = "1.8.10";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "LacusCore";
    rev = "refs/tags/v${version}";
    hash = "sha256-X3Bs/eMkpobRqiGB70ujvaIO1xWftEBZFyR9i5eN7/A=";
  };

  pythonRelaxDeps = [
    "redis"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "lacuscore"
  ];

  meta = with lib; {
    description = "The modulable part of Lacus";
    homepage = "https://github.com/ail-project/LacusCore";
    changelog = "https://github.com/ail-project/LacusCore/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
