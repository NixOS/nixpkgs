{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, poetry-dynamic-versioning
, pyjwt
, pytest-aiohttp
, pytest-freezegun
, pytestCheckHook
, pythonOlder
, deepdiff
}:

buildPythonPackage rec {
  pname = "pylitterbot";
  version = "2023.4.9";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "natekspencer";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-QsxzwmAdhx0diPJ/bT+DgJSs70YQ77M76rq2opMq/Ew=";
  };

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  propagatedBuildInputs = [
    aiohttp
    deepdiff
    pyjwt
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytest-freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pylitterbot"
  ];

  meta = with lib; {
    description = "Modulefor controlling a Litter-Robot";
    homepage = "https://github.com/natekspencer/pylitterbot";
    changelog = "https://github.com/natekspencer/pylitterbot/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
