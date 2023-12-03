{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, aiofiles
, aiohttp
, backports-datetime-fromisoformat
, click
, click-log
, emoji
, glom
, jinja2
, pyyaml
, freezegun
, setuptools
}:

buildPythonPackage rec {
  pname = "dinghy";
  version = "1.3.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nedbat";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-0U08QHQuNm7qaxhU8sNxeN0fZ4S8N0RYRsWjFUqhZSU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    backports-datetime-fromisoformat
    click
    click-log
    emoji
    glom
    jinja2
    pyyaml
  ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dinghy.cli"
  ];

  meta = with lib; {
    description = "A GitHub activity digest tool";
    homepage = "https://github.com/nedbat/dinghy";
    changelog = "https://github.com/nedbat/dinghy/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ trundle veehaitch ];
  };
}
