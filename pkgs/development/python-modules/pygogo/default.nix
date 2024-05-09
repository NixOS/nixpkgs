{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, pkutils
  # Check Inputs
, nose
}:

buildPythonPackage rec {
  pname = "pygogo";
  version = "0.13.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "reubano";
    repo = "pygogo";
    rev = "v${version}";
    sha256 = "19rdf4sjrm5lp1vq1bki21a9lrkzz8sgrfwgjdkq4sgy90hn1jn9";
  };

  nativeBuildInputs = [
    pkutils
  ];

  nativeCheckInputs = [
    nose
  ];

  postPatch = ''
    substituteInPlace dev-requirements.txt \
      --replace "pkutils>=1.0.0,<2.0.0" "pkutils>=1.0.0"
  '';

  checkPhase = ''
    runHook preCheck
    nosetests
    runHook postCheck
  '';

  pythonImportsCheck = [
    "pygogo"
  ];

  meta = with lib; {
    description = "Python logging library";
    homepage = "https://github.com/reubano/pygogo/";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
