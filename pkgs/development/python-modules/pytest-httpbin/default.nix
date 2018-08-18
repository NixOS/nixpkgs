{ buildPythonPackage
, lib
, fetchFromGitHub
, pytest
, flask
, decorator
, httpbin
, six
, requests
}:

buildPythonPackage rec {
  pname = "pytest-httpbin";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "kevin1024";
    repo = "pytest-httpbin";
    rev = "v${version}";
    sha256 = "0p86ljx775gxxicscs1dydmmx92r1g9bs00vdvxrsl3qdll1ksfm";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ flask decorator httpbin six requests ];

  checkPhase = ''
    py.test
  '';

  # https://github.com/kevin1024/pytest-httpbin/pull/51
  doCheck = false;

  meta = {
    description = "Easily test your HTTP library against a local copy of httpbin.org";
    homepage = https://github.com/kevin1024/pytest-httpbin;
    license = lib.licenses.mit;
  };
}

