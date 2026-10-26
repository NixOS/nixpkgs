{
  lib,
  aiohttp,
  bidict,
  buildPythonPackage,
  fetchFromGitHub,
  humanize,
  lxml,
  pytestCheckHook,
  requests,
  slixmpp,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "gekitchen";
  version = "0.2.19";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ajmarks";
    repo = "gekitchen";
    rev = "v${finalAttrs.version}";
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

  meta = {
    description = "Python SDK for GE smart appliances";
    homepage = "https://github.com/ajmarks/gekitchen";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
