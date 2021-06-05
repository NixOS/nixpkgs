{ lib
, buildPythonPackage
, fetchFromGitHub
, georss-client
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "georss-qld-bushfire-alert-client";
  version = "0.4";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-qld-bushfire-alert-client";
    rev = "v${version}";
    sha256 = "14k7q0ynray1fj0lhxvgxpbdh4pmsqqk9gzmv38p9i7ijx8h1sc8";
  };

  propagatedBuildInputs = [
    georss-client
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "georss_qld_bushfire_alert_client" ];

  meta = with lib; {
    description = "Python library for accessing Queensland Bushfire Alert feed";
    homepage = "https://github.com/exxamalte/python-georss-qld-bushfire-alert-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
