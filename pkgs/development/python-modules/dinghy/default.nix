{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
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
  version = "0.13.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nedbat";
    repo = pname;
    rev = version;
    sha256 = "sha256-uRiWcrs3xIb6zxNg0d6/+NCqnEgadHSTLpS53CoZ5so=";
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

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dinghy.cli" ];

  meta = with lib; {
    description = "A GitHub activity digest tool";
    homepage = "https://github.com/nedbat/dinghy";
    license = licenses.asl20;
    maintainers = with maintainers; [ trundle veehaitch ];
  };
}
