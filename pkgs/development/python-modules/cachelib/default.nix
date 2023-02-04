{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-xprocess
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cachelib";
  version = "0.9.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-LO1VdirKWXIAy3U8oRtnFI58qO+yn6Vm5bZdCjdgKwo=";
  };

  nativeCheckInputs = [
    pytest-xprocess
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cachelib" ];

  meta = with lib; {
    homepage = "https://github.com/pallets/cachelib";
    description = "Collection of cache libraries in the same API interface";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gebner ];
  };
}
