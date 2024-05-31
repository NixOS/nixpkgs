{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  pycountry,
}:

buildPythonPackage rec {
  pname = "itunespy";
  version = "1.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sleepyfran";
    repo = pname;
    rev = version;
    sha256 = "0yc3az5531qs8nbcw4rhgrszwczgy4bikfwfar7xb2044360sslw";
  };

  propagatedBuildInputs = [
    requests
    pycountry
  ];

  # This module has no tests
  doCheck = false;

  pythonImportsCheck = [ "itunespy" ];

  meta = with lib; {
    description = "A simple library to fetch data from the iTunes Store API";
    homepage = "https://github.com/sleepyfran/itunespy";
    license = licenses.mit;
    maintainers = with maintainers; [ j0hax ];
  };
}
