{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, ordered-set
, orjson
, clevercsv
, jsonpickle
, numpy
, pytestCheckHook
, python-dateutil
, pyyaml
, toml
, pythonOlder
}:

buildPythonPackage rec {
  pname = "deepdiff";
  version = "6.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "seperman";
    repo = "deepdiff";
    rev = "refs/tags/${version}";
    hash = "sha256-txZ1X1J8DwueDRpLP3OuRA+S9hc5G3YCmEG+AS6ZAkI=";
  };

  postPatch = ''
    substituteInPlace tests/test_command.py \
      --replace '/tmp/' "$TMPDIR/"
  '';

  propagatedBuildInputs = [
    ordered-set
    orjson
  ];

  passthru.optional-dependencies = {
    cli = [
      clevercsv
      click
      pyyaml
      toml
    ];
  };

  nativeCheckInputs = [
    jsonpickle
    numpy
    pytestCheckHook
    python-dateutil
  ] ++ passthru.optional-dependencies.cli;

  pythonImportsCheck = [
    "deepdiff"
  ];

  meta = with lib; {
    description = "Deep Difference and Search of any Python object/data";
    homepage = "https://github.com/seperman/deepdiff";
    changelog = "https://github.com/seperman/deepdiff/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
