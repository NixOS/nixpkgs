{ lib
, authlib
, buildPythonPackage
, fetchFromGitHub
, httpx
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiosenz";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "milanmeu";
    repo = pname;
    rev = version;
    sha256 = "sha256-ODdWPS14zzptxuS6mff51f0s1SYnIqjF40DmvT0sL0w=";
  };

  propagatedBuildInputs = [
    httpx
    authlib
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aiosenz"
  ];

  meta = with lib; {
    description = "Python wrapper for the nVent Raychem SENZ RestAPI";
    homepage = "https://github.com/milanmeu/aiosenz";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
