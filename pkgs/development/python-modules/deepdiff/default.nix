{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  click,
  ordered-set,
  orjson,
  clevercsv,
  jsonpickle,
  numpy,
  pytestCheckHook,
  python-dateutil,
  pyyaml,
  toml,
  tomli-w,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "deepdiff";
  version = "6.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "seperman";
    repo = "deepdiff";
    rev = "refs/tags/${version}";
    hash = "sha256-YGYprSC5j06Ozg0dUJN5xnba0HUgiXa+d9Ci3czGWoY=";
  };

  postPatch = ''
    substituteInPlace tests/test_command.py \
      --replace '/tmp/' "$TMPDIR/"
  '';

  propagatedBuildInputs = [
    click
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
    tomli-w
  ] ++ passthru.optional-dependencies.cli;

  disabledTests = [
    # not compatible with pydantic 2.x
    "test_pydantic1"
    "test_pydantic2"
  ];

  pythonImportsCheck = [ "deepdiff" ];

  meta = with lib; {
    description = "Deep Difference and Search of any Python object/data";
    mainProgram = "deep";
    homepage = "https://github.com/seperman/deepdiff";
    changelog = "https://github.com/seperman/deepdiff/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
