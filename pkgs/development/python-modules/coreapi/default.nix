{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  django,
  coreschema,
  itypes,
  uritemplate,
  requests,
  pytest,
}:

buildPythonPackage rec {
  pname = "coreapi";
  version = "2.3.3";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = "python-client";
    owner = "core-api";
    rev = version;
    sha256 = "1c6chm3q3hyn8fmjv23qgc79ai1kr3xvrrkp4clbqkssn10k7mcw";
  };

  propagatedBuildInputs = [
    django
    coreschema
    itypes
    uritemplate
    requests
  ];

  nativeCheckInputs = [ pytest ];
  checkPhase = ''
    cd ./tests
    pytest
  '';

  meta = with lib; {
    description = "Python client library for Core API";
    homepage = "https://github.com/core-api/python-client";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
