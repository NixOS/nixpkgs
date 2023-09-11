{ lib
, buildPythonPackage
, fetchFromGitHub
, authlib
, httpx
}:

buildPythonPackage rec {
  pname = "pypoint";
  version = "2.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fredrike";
    repo = "pypoint";
    rev = "v${version}";
    hash = "sha256-fO0un6YIK3jutzUxbu9mSqPZHfLa3pMtfxOy1iV3Qio=";
  };

  propagatedBuildInputs = [
    authlib
    httpx
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pypoint"
  ];

  meta = with lib; {
    description = "Python module for communicating with Minut Point";
    homepage = "https://github.com/fredrike/pypoint";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
