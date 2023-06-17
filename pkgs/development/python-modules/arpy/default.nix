{ lib
, buildPythonPackage
, fetchFromGitHub
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "arpy";
  version = "2.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "viraptor";
    repo = pname;
    rev = version;
    hash = "sha256-jD1XJJhcpJymn0CwZ65U06xLKm1JjHffmx/umEO7a5s=";
  };

  checkInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [ "arpy" ];

  meta = with lib; {
    description = "A library for accessing the archive files and reading the contents";
    homepage = "https://github.com/viraptor/arpy";
    license = licenses.bsd2;
    maintainers = with maintainers; [ thornycrackers ];
  };
}
