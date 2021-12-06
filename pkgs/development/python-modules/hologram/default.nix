{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, python-dateutil
, jsonschema
, dataclasses
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "hologram";
  version = "0.0.14";

  disabled = pythonOlder "3.7";

  propagatedBuildInputs = [
    python-dateutil
    jsonschema
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
  ];

  checkInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "jsonschema<3.2,>=3.0" "jsonschema>=3.0"
  '';

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/We9Bp5GgeHSpEffl2xlBg16kP7n9rhNEz/ZlY2wdOw=";
  };

  meta = with lib; {
    description = "CLI tool for managing data transformation";
    homepage = "https://getdbt.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}
