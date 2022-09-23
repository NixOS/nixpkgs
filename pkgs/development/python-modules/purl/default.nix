{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "purl";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "codeinthehole";
    repo = "purl";
    rev = version;
    sha256 = "sha256-Jb3JRW/PtQ7NlO4eQ9DmTPu/sjvFTg2mztphoIF79gc=";
  };

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "purl"
  ];

  meta = with lib; {
    description = "Immutable URL class for easy URL-building and manipulation";
    homepage = "https://github.com/codeinthehole/purl";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
