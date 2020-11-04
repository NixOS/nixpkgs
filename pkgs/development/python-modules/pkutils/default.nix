{ lib
, pythonOlder
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, semver
  # Check Inputs
, nose
}:

buildPythonPackage rec {
  pname = "pkutils";
  version = "1.1.1";
  disabled = !isPy3k; # some tests using semver fail due to unicode errors on Py2.7

  src = fetchFromGitHub {
    owner = "reubano";
    repo = "pkutils";
    rev = "v${version}";
    sha256 = "01yaq9sz6vyxk8yiss6hsmy70qj642cr2ifk0sx1mlh488flcm62";
  };

  propagatedBuildInputs = [ semver ];

  # Remove when https://github.com/reubano/pkutils/pull/4 merged
  postPatch = ''
    substituteInPlace requirements.txt --replace "semver>=2.2.1,<2.7.3" "semver"
  '';

  checkInputs = [ nose ];
  pythonImportsCheck = [ "pkutils" ];

  checkPhase = "nosetests";

  meta = with lib; {
    description = "A Python packaging utility library";
    homepage = "https://github.com/reubano/pkutils/";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
