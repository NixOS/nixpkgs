{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, jsonschema
}:

buildPythonPackage rec {
  pname = "flask-expects-json";
  version = "1.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Fischerfredl";
    repo = pname;
    rev = version;
    hash = "sha256-CUxuwqjjAb9Fy6xWtX1WtSANYaYr5//vY8k89KghYoQ=";
  };

  propagatedBuildInputs = [ flask jsonschema ];

  # tests aren't included in sdist and don't pass on current flask
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/fischerfredl/flask-expects-json";
    description = "Decorator for REST endpoints in flask. Validate JSON request data.";
    license = licenses.mit;
    maintainers = [];
  };
}
