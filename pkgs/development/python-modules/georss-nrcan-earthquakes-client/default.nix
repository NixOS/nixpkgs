{ lib
, buildPythonPackage
, fetchFromGitHub
, georss-client
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "georss-nrcan-earthquakes-client";
  version = "0.3";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-nrcan-earthquakes-client";
    rev = "v${version}";
    sha256 = "1brn6ycsw3d3znbqi2w2cxjw8hyfb44p2lra18rx2gyvgnkxg19l";
  };

  propagatedBuildInputs = [
    georss-client
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "georss_nrcan_earthquakes_client" ];

  meta = with lib; {
    description = "Python library for accessing Natural Resources Canada Earthquakes feed";
    homepage = "https://github.com/exxamalte/python-georss-nrcan-earthquakes-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
