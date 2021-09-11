{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mutf8";
  version = "1.0.4";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "TkTech";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-99NL4mCvzQmDvaOI2M9PA8UUwIrrEtVHRmJqkd6hNd0=";
  };

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    # Using pytestCheckHook results in test failures
    pytest
  '';

  pythonImportsCheck = [ "mutf8" ];

  meta = with lib; {
    description = "Fast MUTF-8 encoder & decoder";
    homepage = "https://github.com/TkTech/mutf8";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
