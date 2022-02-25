{ lib, buildPythonPackage, fetchFromGitHub, fetchPypi, python-dateutil, jsonref, jsonschema,
  pyyaml, simplejson, six, pytz, msgpack, swagger-spec-validator, rfc3987,
  strict-rfc3339, webcolors, mypy-extensions, jsonpointer, idna, pytest, mock,
  pytest-benchmark, isPy27, enum34 }:

let
  jsonschema320 = jsonschema.overridePythonAttrs (oldAttrs: rec {
    version = "3.2.0";

    src = fetchPypi {
      inherit (oldAttrs) pname;
      inherit version;
      hash = "sha256-yKhbKNN3zHc35G4tnytPRO48Dh3qxr9G3e/HGH0weXo=";
    };

    SETUPTOOLS_SCM_PRETEND_VERSION = version;

    doCheck = false;
  });

  swagger-spec-validator' = swagger-spec-validator.overridePythonAttrs (oldAttrs: rec {
    propagatedBuildInputs = [
      pyyaml
      jsonschema320
      six
    ];
  });
in

buildPythonPackage rec {
  pname = "bravado-core";
  version = "5.17.0";

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-okQA4YJq0lyVJuDzD8mMRlOS/K3gf1qRUpw/5M0LlZE=";
  };

  checkInputs = [
    mypy-extensions
    pytest
    mock
    pytest-benchmark
  ];

  checkPhase = "pytest --benchmark-skip";

  propagatedBuildInputs = [
    python-dateutil
    jsonref
    jsonschema320
    pyyaml
    simplejson
    six
    pytz
    msgpack
    swagger-spec-validator'

    # the following 3 packages are included when jsonschema (3.2) is installed
    # as jsonschema[format], which reflects what happens in setup.py
    rfc3987
    strict-rfc3339
    webcolors
    jsonpointer
    idna
  ] ++ lib.optionals isPy27 [ enum34 ];

  meta = with lib; {
    description = "Library for adding Swagger support to clients and servers";
    homepage = "https://github.com/Yelp/bravado-core";
    license = licenses.bsd3;
    maintainers = with maintainers; [ vanschelven ];
  };
}
