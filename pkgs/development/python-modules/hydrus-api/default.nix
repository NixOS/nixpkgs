{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "hydrus-api";
  version = "5.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-s6gS1rVcbg7hcE63hGdPhJCcgS4N4d58MpSrECAfe0U=";
  };

  disabled = pythonOlder "3.9";

  propagatedBuildInputs = [
    requests
  ];

  pythonImportsCheck = [ "hydrus_api" ];

  # There are no unit tests
  doCheck = false;

  meta = with lib; {
    description = "Python module implementing the Hydrus API";
    homepage = "https://gitlab.com/cryzed/hydrus-api";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
