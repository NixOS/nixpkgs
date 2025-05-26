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
    sha256 = "d8787245598e8371a83baa4db1df949d8a942c43f13454fa26ee3b09c3ccafc0";
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
