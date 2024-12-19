{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  more-properties,
  typing-inspect,
  toolz,
  toposort,
  bson,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dataclasses-serialization";
  version = "1.3.1";

  # upstream requires >= 3.6 but only 3.7 includes dataclasses
  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "madman-bob";
    repo = "python-dataclasses-serialization";
    rev = version;
    hash = "sha256-jLMR2D01KgzHHRP0zduMBJt8xgBmIquWLCjZYLo2/AA=";
  };

  postPatch = ''
    mv pypi_upload/setup.py .
    substituteInPlace setup.py \
      --replace "project_root = Path(__file__).parents[1]" "project_root = Path(__file__).parents[0]"

    # dataclasses is included in Python 3.7
    substituteInPlace requirements.txt \
      --replace dataclasses ""

    # https://github.com/madman-bob/python-dataclasses-serialization/issues/16
    sed -i '/(\(Dict\|List\)/d' tests/test_json.py tests/test_bson.py
  '';

  propagatedBuildInputs = [
    more-properties
    typing-inspect
    toolz
    toposort
  ];

  nativeCheckInputs = [
    bson
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dataclasses_serialization.bson"
    "dataclasses_serialization.json"
    "dataclasses_serialization.serializer_base"
  ];

  meta = {
    description = "Serialize/deserialize Python dataclasses to various other data formats";
    homepage = "https://github.com/madman-bob/python-dataclasses-serialization";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
