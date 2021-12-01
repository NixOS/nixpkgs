{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
, aiohttp
, netifaces
, asynctest
, pytest-aiohttp
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-izone";
  version = "1.1.6";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Swamp-Ig";
    repo = "pizone";
    rev = "v${version}";
    sha256 = "sha256-zgE1ccEPSa9nX0SEMN02VEGfnHexk/+jCJe7ugUL5UA=";
  };

  propagatedBuildInputs = [
    aiohttp
    netifaces
  ];

  checkInputs = [
    asynctest
    pytest-aiohttp
    pytestCheckHook
  ];

  patches = [
    # async_timeout 4.0.0 removes current_task, https://github.com/Swamp-Ig/pizone/pull/15
    (fetchpatch {
      name = "remove-current-task.patch";
      url = "https://github.com/Swamp-Ig/pizone/commit/988998cf009a39938e4ee37079337b0c187977f2.patch";
      sha256 = "nVCQBMc4ZE7CQsYC986wqvPPyA7zJ/g278jJrpaiAIw=";
    })
  ];

  pythonImportsCheck = [
    "pizone"
  ];

  meta = with lib; {
    description = "Python interface to the iZone airconditioner controller";
    homepage = "https://github.com/Swamp-Ig/pizone";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
