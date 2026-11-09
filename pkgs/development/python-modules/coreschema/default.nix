{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  jinja2,
  pytest,
}:

buildPythonPackage rec {
  pname = "coreschema";
  version = "0.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = "python-coreschema";
    owner = "core-api";
    rev = version;
    hash = "sha256-YXGDmWTT3cT3vek40HMbCWelmm6nhx3yWOvNOsph9wg=";
  };

  propagatedBuildInputs = [ jinja2 ];

  nativeCheckInputs = [ pytest ];
  checkPhase = ''
    cd ./tests
    pytest
  '';

  meta = {
    description = "Python client library for Core Schema";
    homepage = "https://github.com/ivegotasthma/python-coreschema";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
