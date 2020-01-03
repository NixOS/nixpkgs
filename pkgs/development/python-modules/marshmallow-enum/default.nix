{ lib
, buildPythonPackage
, fetchFromGitHub
, marshmallow
, pytestCheckHook
, isPy27
, enum34
, pytest-flake8
}:

buildPythonPackage rec {
  pname = "marshmallow-enum";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "justanr";
    repo = "marshmallow_enum";
    rev = "v${version}";
    sha256 = "1ihrcmyfjabivg6hc44i59hnw5ijlg1byv3zs1rqxfynp8xr7398";
  };

  propagatedBuildInputs = [
    marshmallow
  ] ++ lib.optionals isPy27 [ enum34 ];

  checkInputs = [
    pytestCheckHook
    pytest-flake8
  ];

  disabledTests = [
    "test_custom_error_in_deserialize_by_name"
    "test_custom_error_in_deserialize_by_value"
  ];

  meta = with lib; {
    description = "Enum field for Marshmallow";
    homepage = https://github.com/justanr/marshmallow_enum;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
