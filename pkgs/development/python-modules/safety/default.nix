{ lib, buildPythonPackage, fetchPypi, requests, dparse, click, setuptools, pytestCheckHook }:

buildPythonPackage rec {
  pname = "safety";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "23bf20690d4400edc795836b0c983c2b4cbbb922233108ff925b7dd7750f00c9";
  };

  propagatedBuildInputs = [ requests dparse click setuptools ];

  # Disable tests depending on online services
  checkInputs = [ pytestCheckHook ];
  dontUseSetuptoolsCheck = true;
  disabledTests = [
    "test_check_live"
    "test_check_live_cached"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description =
      "Safety checks your installed dependencies for known security vulnerabilities";
    homepage = "https://github.com/pyupio/safety";
    license = licenses.mit;
    maintainers = with maintainers; [ thomasdesr ];
  };
}
