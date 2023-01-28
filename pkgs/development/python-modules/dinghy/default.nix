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
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nedbat";
    repo = pname;
    rev = version;
    hash = "sha256-3qj3CU0A7oyPcUMEoqe4lUK5Jl1tlnCaqXMtDnn9+bw=";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ trundle veehaitch ];
  };
}
