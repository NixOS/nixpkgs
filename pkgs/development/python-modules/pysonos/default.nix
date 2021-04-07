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
  version = "0.0.40";

  disabled = !isPy3k;

  # pypi package is missing test fixtures
  src = fetchFromGitHub {
    owner = "amelchio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0a0c7jwv39nbvpdcx32sd8kjmj4nyrd7k0yxhpmxdnx4zr4vvzqg";
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
