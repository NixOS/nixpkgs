{ lib
, buildPythonPackage
, fetchFromGitHub
, authlib
, httpx
}:

buildPythonPackage rec {
  pname = "pypoint";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "fredrike";
    repo = "pypoint";
    rev = "v${version}";
    sha256 = "sha256-2PKZtn+l93de4/gPPM2Wdt04Zw+ekDadwNgL6ZKTqhY=";
  };

  propagatedBuildInputs = [
    authlib
    httpx
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "pypoint" ];

  meta = with lib; {
    description = "API for Minut Point";
    homepage = "https://github.com/fredrike/pypoint";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
