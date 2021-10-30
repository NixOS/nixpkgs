{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cachetools";
  version = "4.2.3";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tkem";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9CHXvb+Nn3N2oWHwNbqKguzDO/q+4EnMZ50+E+MWS/A=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cachetools" ];

  meta = with lib; {
    description = "Extensible memoizing collections and decorators";
    homepage = "https://github.com/tkem/cachetools";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
