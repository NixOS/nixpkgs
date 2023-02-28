{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, poetry-core
, requests
}:

buildPythonPackage rec {
  pname = "hydrus-api";
  version = "5.0.0";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "hydrus_api";
    sha256 = "sha256-s6gS1rVcbg7hcE63hGdPhJCcgS4N4d58MpSrECAfe0U=";
  };

  patches = [ ./poetry-core.patch ];

  disabled = pythonOlder "3.9";

  nativeBuildInputs = [ poetry-core ];

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
