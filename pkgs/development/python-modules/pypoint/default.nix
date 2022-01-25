{ lib
, buildPythonPackage
, fetchFromGitHub
, authlib
, httpx
}:

buildPythonPackage rec {
  pname = "pypoint";
  version = "2.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fredrike";
    repo = "pypoint";
    rev = "v${version}";
    sha256 = "sha256-Or7A/Br6BgiCF6OHRtN5TAt++Tu1RLS9mYRgD7Aljts=";
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
