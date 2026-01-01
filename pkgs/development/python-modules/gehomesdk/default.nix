{
  lib,
  aiohttp,
<<<<<<< HEAD
  beautifulsoup4,
  bidict,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  humanize,
  pytestCheckHook,
  requests,
  setuptools,
=======
  bidict,
  buildPythonPackage,
  fetchPypi,
  humanize,
  lxml,
  pythonOlder,
  requests,
  setuptools,
  slixmpp,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  websockets,
}:

buildPythonPackage rec {
  pname = "gehomesdk";
<<<<<<< HEAD
  version = "2025.11.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HS33yTE+3n0DKRD4+cr8zAE+xcW1ca7q8inQ7qwKJMA=";
=======
  version = "2025.5.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YMw0W9EWz3KY1+aZMdtE4TRvFd9yqTHkfw0X3+ZDCfQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
<<<<<<< HEAD
    beautifulsoup4
    bidict
    humanize
    requests
    websockets
  ];

  nativeCheckInputs = [
    pytestCheckHook
    cryptography
  ];

  pythonImportsCheck = [ "gehomesdk" ];

  meta = {
    description = "Python SDK for GE smart appliances";
    homepage = "https://github.com/simbaja/gehome";
    changelog = "https://github.com/simbaja/gehome/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
    bidict
    humanize
    lxml
    requests
    slixmpp
    websockets
  ];

  # Tests are not shipped and source is not tagged
  # https://github.com/simbaja/gehome/issues/32
  doCheck = false;

  pythonImportsCheck = [ "gehomesdk" ];

  meta = with lib; {
    description = "Python SDK for GE smart appliances";
    homepage = "https://github.com/simbaja/gehome";
    changelog = "https://github.com/simbaja/gehome/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "gehome-appliance-data";
  };
}
