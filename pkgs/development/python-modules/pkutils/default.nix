{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, pythonOlder
, semver
}:

buildPythonPackage rec {
  pname = "pkutils";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "reubano";
    repo = "pkutils";
    rev = "v${version}";
    sha256 = "sha256-jvRUjuxlcfmJOX50bnZR/pP2Axe1KDy9/KGXTL4yPxA=";
  };

  propagatedBuildInputs = [
    semver
  ];

  checkInputs = [
    nose
  ];

  postPatch = ''
    # Remove when https://github.com/reubano/pkutils/pull/4 merged
    substituteInPlace requirements.txt \
      --replace "semver>=2.2.1,<2.7.3" "semver"
  '';

  checkPhase = ''
    runHook preCheck
    nosetests
    runHook postCheck
  '';

  pythonImportsCheck = [
    "pkutils"
  ];

  meta = with lib; {
    description = "A Python packaging utility library";
    homepage = "https://github.com/reubano/pkutils/";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
