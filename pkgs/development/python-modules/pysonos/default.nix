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
  version = "0.0.50";

  disabled = !isPy3k;

  # pypi package is missing test fixtures
  src = fetchFromGitHub {
    owner = "amelchio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iyFdT+RH2dtMtD+jSLFuAVE1DIQn6k9ONLOXNFhpuHs=";
  };

  propagatedBuildInputs = [
    ifaddr
    requests
    xmltodict
  ];

  checkInputs = [
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
