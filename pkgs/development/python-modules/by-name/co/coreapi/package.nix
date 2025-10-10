{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonAtLeast,
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

  # cgi module was removed in 3.13, upstream repo archived since 2019
  disabled = pythonAtLeast "3.13";

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
