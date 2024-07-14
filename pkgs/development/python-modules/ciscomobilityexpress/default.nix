{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  python,
}:

buildPythonPackage rec {
  pname = "ciscomobilityexpress";
  version = "1.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2HhyRVmOg3GoO6pNsd+UnYqULEPxNFT6Ju47CcPMr8A=";
  };

  propagatedBuildInputs = [ requests ];

  # tests directory is set up, but has no tests
  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  pythonImportsCheck = [ "ciscomobilityexpress" ];

  meta = with lib; {
    description = "Module to interact with Cisco Mobility Express APIs to fetch connected devices";
    homepage = "https://github.com/fbradyirl/ciscomobilityexpress";
    license = licenses.mit;
    maintainers = with maintainers; [ uvnikita ];
  };
}
