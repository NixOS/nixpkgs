{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pyjwt
, pytest-aiohttp
, pytest-freezegun
, pytestCheckHook
, pythonOlder
, deepdiff
}:

buildPythonPackage rec {
  pname = "pylitterbot";
  version = "2023.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "natekspencer";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-PSg0u4Beg0OVUMxaBCPxJSVO/MxBvCpDu2rQhiYT9OM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    deepdiff
    pyjwt
  ];

  checkInputs = [
    aioresponses
    pytest-aiohttp
    pytest-freezegun
    pytestCheckHook
  ];

  postPatch = ''
    # https://github.com/natekspencer/pylitterbot/issues/73
    substituteInPlace pyproject.toml \
      --replace 'deepdiff = "^5.8.1"' 'deepdiff = ">=5.8.1"'
  '';

  pythonImportsCheck = [
    "pylitterbot"
  ];

  meta = with lib; {
    description = "Modulefor controlling a Litter-Robot";
    homepage = "https://github.com/natekspencer/pylitterbot";
    changelog = "https://github.com/natekspencer/pylitterbot/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
