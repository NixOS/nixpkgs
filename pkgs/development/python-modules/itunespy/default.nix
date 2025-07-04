{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  pycountry,
}:

buildPythonPackage rec {
  pname = "itunespy";
  version = "1.6.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sleepyfran";
    repo = "itunespy";
    tag = "v${version}";
    sha256 = "sha256-QvSKJAZa8v0tGURXwo4Dwo73JqsYs1xsBHW0lcaM7bk=";
  };

  propagatedBuildInputs = [
    requests
    pycountry
  ];

  # This module has no tests
  doCheck = false;

  pythonImportsCheck = [ "itunespy" ];

  meta = with lib; {
    description = "Simple library to fetch data from the iTunes Store API";
    homepage = "https://github.com/sleepyfran/itunespy";
    license = licenses.mit;
    maintainers = with maintainers; [ j0hax ];
  };
}
