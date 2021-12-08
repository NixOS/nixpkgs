{ lib
, fetchFromGitHub
, buildPythonPackage
}:
buildPythonPackage rec {
  pname = "banal";
  version = "1.0.6";

  src = fetchFromGitHub {
     owner = "pudo";
     repo = "banal";
     rev = "1.0.6";
     sha256 = "19042ka89czaic3sm1aj5014xvw854id6yy9z07msmymmz5l9cqx";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "banal"
  ];

  meta = with lib; {
    description = "Commons of banal micro-functions for Python";
    homepage = "https://github.com/pudo/banal";
    license = licenses.mit;
    maintainers = teams.determinatesystems.members;
  };
}
