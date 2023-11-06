{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, aiofiles
, aiohttp
, click-log
, emoji
, glom
, jinja2
, pyyaml
}:

buildPythonPackage rec {
  pname = "dinghy";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nedbat";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-a1CHbPSoiR3JbuAXYPJc1EsSq13DbrOttk9zLFF9+cM=";
  };

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    click-log
    emoji
    glom
    jinja2
    pyyaml
  ];

  nativeCheckInputs = [
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
