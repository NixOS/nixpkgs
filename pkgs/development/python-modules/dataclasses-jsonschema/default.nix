{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, isPy3k
, dataclasses
, python-dateutil
, jsonschema
, typing-extensions
, pytest
, flake8
, mypy
, apispec
, apispec-webframeworks
, flask
, pytest-runner
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dataclasses-jsonschema";
  version = "2.14.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "153v7vkkhqhiz7mzxbslbgqp2z7xcgh9hvg3lyppjaigi3pa22sg";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace setup.py \
      --replace ", 'pytest-ordering'" ""
  '';

  nativeBuildInputs = [
    setuptools-scm
    pytest-runner
  ];

  propagatedBuildInputs = [
    python-dateutil
    jsonschema
  ] ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ]
    ++ lib.optionals (pythonOlder "3.7") [ dataclasses ];

  disabledTests = [
    "embeddable"
  ];

  checkInputs = [
    pytestCheckHook
    mypy
    apispec
    apispec-webframeworks
    flask
  ];

  pythonImportsCheck = [
    "dataclasses_jsonschema"
  ];

  meta = with lib; {
    description = "JSON schema generation from dataclasses";
    homepage = "https://github.com/s-knibbs/dataclasses-jsonschema";
    license = licenses.mit;
    maintainers = with maintainers; [ glittershark ];
  };
}
