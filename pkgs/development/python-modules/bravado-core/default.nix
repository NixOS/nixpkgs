{ lib, buildPythonPackage, fetchFromGitHub, python-dateutil, jsonref, jsonschema,
  pyyaml, simplejson, six, pytz, msgpack, swagger-spec-validator, rfc3987,
  strict-rfc3339, webcolors, mypy-extensions, jsonpointer, idna, pytest, mock,
  pytest-benchmark, isPy27, enum34 }:

buildPythonPackage rec {
  pname = "bravado-core";
  version = "5.16.1";

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0r9gk5vkjbc407fjydms3ik3hnzajq54znyz58d8rm6pvqcvjjpl";
  };

  checkInputs = [
    mypy-extensions
    pytest
    mock
    pytest-benchmark
  ];

  checkPhase = ''pytest --benchmark-skip'';

  propagatedBuildInputs = [
    python-dateutil
    jsonref
    jsonschema
    pyyaml
    simplejson
    six
    pytz
    msgpack
    swagger-spec-validator

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
