{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylru";
  version = "1.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jlhutch";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dTYiD+/zt0ZSP+sefYyeD87To1nRXyoFodlBg8pm1YE=";
  };

  # Check with the next release if tests are ready
  doCheck = false;

  pythonImportsCheck = [
    "pylru"
  ];

  meta = with lib; {
    description = "A least recently used (LRU) cache implementation";
    homepage = "https://github.com/jlhutch/pylru";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ abbradar ];
  };
}
