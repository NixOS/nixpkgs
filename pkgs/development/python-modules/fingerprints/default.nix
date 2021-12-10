{ lib
, fetchFromGitHub
, buildPythonPackage
, normality
, mypy
, coverage
, nose
}:
buildPythonPackage rec {
  pname = "fingerprints";
  version = "1.0.3";

  src = fetchFromGitHub {
     owner = "alephdata";
     repo = "fingerprints";
     rev = "1.0.3";
     sha256 = "0kvprp0rcaqdbqp6sm08vch53dlfgvcc6xyvi6v9lwhrhx8i3hgi";
  };

  propagatedBuildInputs = [
    normality
  ];

  checkInputs = [
    mypy
    coverage
    nose
  ];

  checkPhase = ''
    nosetests
  '';

  pythonImportsCheck = [
    "fingerprints"
  ];

  meta = with lib; {
    description = "A library to generate entity fingerprints";
    homepage = "https://github.com/alephdata/fingerprints";
    license = licenses.mit;
    maintainers = teams.determinatesystems.members;
  };
}
