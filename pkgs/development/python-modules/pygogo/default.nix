{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, pkutils
  # Check Inputs
, pytestCheckHook
, nose
}:

buildPythonPackage rec {
  pname = "pygogo";
  version = "0.13.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "reubano";
    repo = "pygogo";
    rev = "v${version}";
    sha256 = "19rdf4sjrm5lp1vq1bki21a9lrkzz8sgrfwgjdkq4sgy90hn1jn9";
  };

  nativeBuildInputs = [ pkutils ];

  checkInputs = [ nose ];
  checkPhase = "nosetests";
  pythonImportsCheck = [ "pygogo" ];

  meta = with lib; {
    description = "A Python logging library with super powers";
    homepage = "https://github.com/reubano/pygogo/";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
