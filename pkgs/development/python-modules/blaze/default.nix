{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, flask
, flask-cors
, odo
, psutil
, sqlalchemy
}:

let
  disabledTests = [
    "test_table_resource"
    "test_can_trivially_create_csv_data"
    "test_data_passes_kwargs_to_resource"
    "test_all_string_infer_header"
    "test_csv_with_trailing_commas"
    "test_Data_attribute_repr"
  ];

  testExpression = lib.optionalString (disabledTests != [])
    "-k 'not ${lib.concatStringsSep " and not " disabledTests}'";

in buildPythonPackage rec {
  pname = "blaze";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0w916k125058p40cf7i090f75pgv3cqdb8vwjzqhb9r482fa6717";
  };

  checkInputs = [
    pytest
  ];
  propagatedBuildInputs = [
    flask
    flask-cors
    odo
    psutil
    sqlalchemy
  ];

  checkPhase = ''
    rm pytest.ini # Not interested in coverage
    py.test blaze/tests ${testExpression}
  '';

  meta = {
    homepage = https://github.com/ContinuumIO/blaze;
    description = "Allows Python users a familiar interface to query data living in other data storage systems";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ fridh ];
  };
}