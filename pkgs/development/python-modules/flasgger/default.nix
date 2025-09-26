{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # dependencies
  flask,
  jsonschema,
  mistune,
  pyyaml,
  six,
  werkzeug,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flasgger";
  version = "0.9.7.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "flasgger";
    repo = "flasgger";
    rev = "v${version}";
    hash = "sha256-ULEf9DJiz/S2wKlb/vjGto8VCI0QDcm0pkU5rlOwtiE=";
  };

  propagatedBuildInputs = [
    flask
    jsonschema
    mistune
    pyyaml
    six
    werkzeug
  ];

  pythonImportsCheck = [ "flasgger" ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = false; # missing flex dependency

  meta = with lib; {
    description = "Easy OpenAPI specs and Swagger UI for your Flask API";
    homepage = "https://github.com/flasgger/flasgger/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
