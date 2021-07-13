{ lib
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "iso3166";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "deactivated";
    repo = "python-iso3166";
    rev = "v${version}";
    sha256 = "0zs9za9dr2nl5srxir08yibmp6nffcapmzala0fgh8ny7y6rafrx";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "iso3166" ];

  meta = with lib; {
    homepage = "https://github.com/deactivated/python-iso3166";
    description = "Self-contained ISO 3166-1 country definitions";
    license = licenses.mit;
    maintainers = with maintainers; [ zraexy ];
  };
}
