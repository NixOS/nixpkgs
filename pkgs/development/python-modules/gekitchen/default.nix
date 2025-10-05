{
  lib,
  aiohttp,
  bidict,
  buildPythonPackage,
  fetchFromGitHub,
  humanize,
  lxml,
  pytestCheckHook,
  pythonOlder,
  requests,
  slixmpp,
  websockets,
}:

buildPythonPackage rec {
  pname = "gekitchen";
  version = "0.2.19";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ajmarks";
    repo = "gekitchen";
    rev = "v${version}";
    hash = "sha256-eKGundh7j9LqFd71bx86rNBVu2iAcgLN25JfFa39+VA=";
  };

  propagatedBuildInputs = [
    aiohttp
    bidict
    humanize
    lxml
    requests
    slixmpp
    websockets
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gekitchen" ];

  meta = with lib; {
    description = "Python SDK for GE smart appliances";
    homepage = "https://github.com/ajmarks/gekitchen";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
