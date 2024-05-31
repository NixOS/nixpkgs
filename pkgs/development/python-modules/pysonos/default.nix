{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy3k,
  xmltodict,
  ifaddr,
  requests,

  # Test dependencies
  pytestCheckHook,
  mock,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "pysonos";
  version = "0.0.54";
  format = "setuptools";

  disabled = !isPy3k;

  # pypi package is missing test fixtures
  src = fetchFromGitHub {
    owner = "amelchio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gBOknYHL5nQWFVhCbLN0Ah+1fovcNY4P2myryZnUadk=";
  };

  propagatedBuildInputs = [
    ifaddr
    requests
    xmltodict
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    requests-mock
  ];

  disabledTests = [
    "test_desc_from_uri" # test requires network access
  ];

  meta = with lib; {
    description = "A SoCo fork with fixes for Home Assistant";
    homepage = "https://github.com/amelchio/pysonos";
    license = licenses.mit;
    maintainers = with maintainers; [ juaningan ];
  };
}
