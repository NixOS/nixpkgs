{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, xmltodict
, ifaddr
, requests

  # Test dependencies
, pytestCheckHook
, mock
, requests-mock
}:

buildPythonPackage rec {
  pname = "pysonos";
  version = "0.0.45";

  disabled = !isPy3k;

  # pypi package is missing test fixtures
  src = fetchFromGitHub {
    owner = "amelchio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wzmrd9ja5makvsgf0ckil99wr8vw91dml8fi9miiq4la0100q0n";
  };

  propagatedBuildInputs = [ ifaddr requests xmltodict ];

  checkInputs = [
    pytestCheckHook
    mock
    requests-mock
  ];

  disabledTests = [
    "test_desc_from_uri" # test requires network access
  ];

  meta = {
    homepage = "https://github.com/amelchio/pysonos";
    description = "A SoCo fork with fixes for Home Assistant";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
