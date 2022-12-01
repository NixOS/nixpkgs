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
  version = "0.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nedbat";
    repo = pname;
    rev = version;
    hash = "sha256-bfB1VVeIl1KzjY0oQ0jQ8M/fK5LZQqYU7AX201QX+Mk=";
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

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dinghy.cli"
  ];

  meta = with lib; {
    description = "A GitHub activity digest tool";
    homepage = "https://github.com/nedbat/dinghy";
    license = licenses.asl20;
    maintainers = with maintainers; [ trundle veehaitch ];
  };
}
