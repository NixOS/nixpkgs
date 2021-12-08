{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, python
}:

buildPythonPackage rec {
  pname = "ciscomobilityexpress";
  version = "1.0.2";

  src = fetchFromGitHub {
     owner = "fbradyirl";
     repo = "ciscomobilityexpress";
     rev = "v1.0.2";
     sha256 = "0mg1r07z1lqb06426zj8pdc7mxzmch04s3408i88bfm60piwpvqc";
  };

  propagatedBuildInputs = [ requests ];

  # tests directory is set up, but has no tests
  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  pythonImportsCheck = [
    "ciscomobilityexpress"
  ];

  meta = with lib; {
    description = "Module to interact with Cisco Mobility Express APIs to fetch connected devices";
    homepage = "https://github.com/fbradyirl/ciscomobilityexpress";
    license = licenses.mit;
    maintainers = with maintainers; [ uvnikita ];
  };
}
